class_name RyuMoveListComponent extends MoveListComponent

signal command_animation(command)

@export var Hado : Special_Attack
@export var Shoryu : Special_Attack
@export var Tatsu : Special_Attack

@onready var command_attacks = [Hado, Shoryu, Tatsu]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



