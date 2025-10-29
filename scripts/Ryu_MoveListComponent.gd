class_name RyuMoveListComponent extends MoveListComponent



@export var LHado : Attack
@export var MHado : Attack
@export var HHado : Attack

@onready var command_attacks = [LHado, MHado, HHado]

# Called when the node enters the scene tree for the first time.
func _ready():
	print(command_attacks)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
