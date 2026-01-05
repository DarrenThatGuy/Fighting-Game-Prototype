class_name Fighter extends CharacterBody2D

signal send_attack(attack)

@onready var _sprite: AnimatedSprite2D = $PlayerSprites
@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree : AnimationTree = $AnimationTree
@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")

@export var MoveList : MoveListComponent

var current_movelist

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var _was_on_floor: bool = false
var is_crouching = false
var current_attack
var current_command
var direction
var last_velocity

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_input_tracker_command_move(command):
	current_command = command

func _process(delta):
	var current_animation_name = _animation_state_machine.get_current_node()

func _physics_process(delta):
	
	direction = Input.get_axis("Left", "Right")
	last_velocity = velocity.x
	if direction and is_on_floor():
		velocity.x = direction * SPEED
	elif !is_on_floor():
		velocity.x = last_velocity
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if !is_on_floor():
		current_movelist = MoveList.jumping_control_dict
	elif is_crouching:
		current_movelist = MoveList.crouching_control_dict
	else:
		current_movelist = MoveList.standing_control_dict
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
			if !is_crouching:
				_animation_state_machine.travel("Idle")
			else:
				pass
		else:
			if !is_on_floor():
				print("not on floor")
			else:
				_animation_state_machine.travel("Move")
	
		_animation_tree["parameters/Move/blend_position"] = signf(velocity.x)


func _on_airborne_state_entered():
	print(_animation_state_machine.get_current_node())
	velocity.y = JUMP_VELOCITY
	"""if last_velocity > 0:
		_animation_state_machine.travel("forward_jump")
	elif last_velocity < 0:
		_animation_state_machine.travel("backward_jump")
	else:"""
	
	last_velocity = velocity.x
	direction = 0

func _on_jump_enabled_state_physics_processing(delta):
	if Input.is_action_just_pressed("Up"):
		_animation_state_machine.travel("start_jump")
		_animation_state_machine.travel("vertical_jump")
		_state_chart.send_event("jump")



func _on_attacking_state_entered():
	if current_attack:
		_animation_state_machine.travel(current_attack)
	elif current_command:
		_animation_state_machine.travel(current_command)
	else:
		print("no attack")
			

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == current_attack or anim_name == current_command:
		_state_chart.send_event("grounded")
	else:
		return

func _on_grounded_state_entered():
	current_attack = null
	current_command = null

func _on_input_tracker_switch_state(state_name, attack):
	current_attack = attack
	_state_chart.send_event(state_name)


func _on_grounded_state_input(event):
		if Input.is_action_just_pressed("Down"):
			is_crouching = true
			_state_chart.send_event("crouching")


func _on_crouching_state_entered():
	_animation_state_machine.travel("start_crouch")
	await $AnimationTree.animation_finished
	_animation_state_machine.travel("crouching")

func _on_crouching_state_processing(delta):
	if Input.is_action_just_released("Down"):
		_state_chart.send_event("grounded")

func _on_crouching_state_exited():
	is_crouching = false



