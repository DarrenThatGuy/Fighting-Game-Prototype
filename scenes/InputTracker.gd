extends Node2D

var framecount = 0
var input_direction = Input.get_vector("Left", 'Right', "Up", "Down")
@export var input_buffer = []
var input_buffer_max_size = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	framecount = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	framecount += 1
	if framecount == 400:
		input_buffer.pop_front()
		framecount = 0
	var current_numpad_input = get_numpad_direction(Input.get_vector("Left", "Right", "Up", "Down"))
	if (input_buffer.is_empty() or input_buffer.back() != current_numpad_input) and current_numpad_input != "5":
		input_buffer.push_back(current_numpad_input)
		if input_buffer.size() > input_buffer_max_size:
			input_buffer.pop_front()


func _on_base_character_send_attack(attack):
	input_buffer.append(attack)

func get_numpad_direction(direction_vector: Vector2) -> String:
	print(input_buffer)
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
	
