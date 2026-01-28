class_name MoveListComponent extends Node


@export var standing_light_combo : Attack
@export var standing_medium_combo : Attack
@export var standing_heavy_combo : Attack

@export var crouching_LP : Attack
@export var crouching_MP : Attack
@export var crouching_HP : Attack

@export var jumping_LP : Attack
@export var jumping_MP : Attack
@export var jumping_HP : Attack

@onready var control_dict = {"light_combo" : standing_light_combo, "medium_combo" : standing_medium_combo, "heavy_combo" : standing_heavy_combo}
