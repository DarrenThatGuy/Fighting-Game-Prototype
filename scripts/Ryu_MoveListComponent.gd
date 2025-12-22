class_name RyuMoveListComponent extends MoveListComponent

signal command_animation(command)


@export var LHado : Attack
@export var MHado : Attack
@export var HHado : Attack
@export var LShoryu : Attack
@export var MShoryu : Attack
@export var HShoryu : Attack
@export var LTatsu : Attack
@export var MTatsu : Attack
@export var HTatsu : Attack

@onready var command_attacks = [LHado, MHado, HHado, LShoryu, MShoryu, HShoryu, LTatsu, MTatsu, HTatsu]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_tracker_command_move(command : Attack):
	command_animation.emit(command.name)
	if command == LHado or command == MHado or command == HHado:
		print("Shoot Hadoken Projectile")
	elif command == LShoryu or command == MShoryu or command == HShoryu:
		print("Do Uppercut animation with hitboxes")
	elif command == LTatsu or command == MTatsu or command == HTatsu:
		print("Do Tatsu animation with hitboxes")
