extends Node2D

var framecount = 0
var input_direction = Input.get_vector("Left", 'Right', "Up", "Down")
var input_buffer = []
@export var character_move_list : MoveListComponent
var input_buffer_max_size = 15
@onready var commands = character_move_list.command_attacks

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
		if input_buffer.size() > input_buffer_max_size:
			input_buffer.pop_front()


func _on_base_character_send_attack(attack):
	input_buffer.append(attack)
	for attack_resource in commands:
		find_command(input_buffer, attack_resource)
	input_buffer.clear()

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
	
func find_command(current_command : Array, attack : Attack) -> Attack:
	var attack_to_match = []
	var command_to_check = attack.command
	var index = 0
	var command_index = 0
	print(current_command)
	print(attack.command)
	if command_to_check.size() > current_command.size():
		return null
	while index <= current_command.size()-1 and command_index <= command_to_check.size()-1:
		if current_command[index] == command_to_check[command_index]:
			attack_to_match.append(current_command[index])
			index += 1
			command_index += 1
		else:
			index += 1
	if attack_to_match == attack.command:
		return attack
	else:
		print("No Match Found")
		return null
	return null
