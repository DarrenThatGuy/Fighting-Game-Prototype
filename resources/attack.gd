class_name Attack extends Resource

@export var name : String
@export var animation : String
@export var has_command : bool
@export var command : Array
@export var damage : int
@export var hitstun : float
@export var hitstop : float

func ready():
	name == resource_name
