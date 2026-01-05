extends Node2D

@onready var parent = get_parent()
@export var character_move_list : MoveListComponent
@onready var commands = character_move_list.command_attacks

var framecount = 0
var input_direction = Input.get_vector("Left", 'Right', "Up", "Down")
var input_buffer = []
var input_buffer_max_size = 15
var current_command
var current_attack

signal send_attack(attack)
signal command_move(command)
signal switch_state(state_name, attack)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	framecount = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !input_buffer.is_empty():
		framecount += 1
		if framecount == 1000:
			input_buffer.pop_front()
			framecount = 0
	else:
		framecount = 0
	var current_numpad_input = get_numpad_direction(Input.get_vector("Left", "Right", "Up", "Down"))
	if (input_buffer.is_empty() or input_buffer.back() != current_numpad_input) and current_numpad_input != "5":
		input_buffer.push_back(current_numpad_input)
		print(input_buffer)
		if input_buffer.size() > input_buffer_max_size:
			input_buffer.pop_front()

func _on_attack_enabled_state_input(event):
	
	var parent_movelist = parent.current_movelist
	
	for attack in parent_movelist:
		if Input.is_action_just_pressed(attack):

			current_attack = attack
			var event_name
			if !parent.is_on_floor():
				event_name = "jumping_" + attack
			elif parent.is_crouching:
				event_name = "crouching_" + attack
			else:
				event_name = "standing_" + attack
			
			send_attack.emit(current_attack)
			if current_command:
				switch_state.emit(current_command.name, current_command.name)
			else:
				switch_state.emit(event_name, current_attack)
			break
		else:
			pass

func _on_send_attack(attack):
	input_buffer.append(attack)
	current_command = find_command(input_buffer, commands)

func get_numpad_direction(direction_vector: Vector2) -> String:
	if direction_vector.x < 0:
		if direction_vector.y < 0:
			return "7"
		elif direction_vector.y > 0:
			return "1"
		else: 
			return "4"
	elif direction_vector.x > 0:
		if direction_vector.y < 0:
			return "9"
		elif direction_vector.y > 0:
			return "3"
		else:
			return "6"
	else:
		if direction_vector.y < 0:
			return "8"
		elif direction_vector.y > 0:
			return "2"
	return "5"
	
func find_command(current_command : Array, movelist) -> Attack:
	var attack_to_match = []
	var index = 0
	var command_index = 0
	for attack_to_check in movelist:
		index = 0
		command_index = 0
		attack_to_match.clear()
		if attack_to_check.command.size() > current_command.size():
			continue
		while index <= current_command.size()-1 and command_index <= attack_to_check.command.size()-1:
			if current_command[index] == attack_to_check.command[command_index]:
				attack_to_match.append(current_command[index])
				index += 1
				command_index += 1
			else:
				index += 1
		if attack_to_match == attack_to_check.command:
			return attack_to_check
		else:
			continue
	return null


