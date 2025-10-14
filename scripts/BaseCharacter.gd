class_name Fighter extends CharacterBody2D

signal send_attack(attack)

@onready var _sprite: AnimatedSprite2D = $PlayerSprites
@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree : AnimationTree = $AnimationTree
@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")

@export var MoveList : MoveListComponent

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var _was_on_floor: bool = false
var is_crouching = false
var current_attack
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
		
	if is_on_floor():
		velocity.y = 0
		
		if not _was_on_floor:
			_was_on_floor = true
			_state_chart.send_event("grounded")
	else:
		velocity.y += gravity * delta
		if _was_on_floor:
			_was_on_floor = false
			_state_chart.send_event("airborne")

	if current_attack == null:
		if velocity.length_squared() <= 0.005:
			_animation_state_machine.travel("Idle")
		else:
			_animation_state_machine.travel("Move")
	
		_animation_tree["parameters/Move/blend_position"] = signf(velocity.x)
	



func _on_jump_enabled_state_physics_processing(delta):
	if Input.is_action_just_pressed("Up"):
		velocity.y = JUMP_VELOCITY
		_state_chart.send_event("jump")


func _on_attack_enabled_state_input(event):
	var current_movelist = MoveList.standing_control_dict
	if !is_on_floor():
		current_movelist = MoveList.jumping_control_dict
	elif is_crouching:
		current_movelist = MoveList.crouching_control_dict
	else:
		current_movelist = MoveList.standing_control_dict
	for attack in current_movelist:
		if Input.is_action_just_pressed(attack):
			current_attack = attack
			if !is_on_floor():
				_state_chart.send_event("jumping_" + attack)
			elif is_crouching:
				_state_chart.send_event("crouching_" + attack)
			else:
				_state_chart.send_event("standing_" + attack)
			send_attack.emit(current_attack)
		else:
			pass
		
func _on_attacking_state_entered():
	_animation_state_machine.travel(current_attack)

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == current_attack:
		_state_chart.send_event("grounded")

func _on_grounded_state_entered():
	current_attack = null
