class_name MoveListComponent extends Node


@export var standing_LP : Attack
@export var standing_MP : Attack
@export var standing_HP : Attack
@export var standing_LK : Attack
@export var standing_MK : Attack
@export var standing_HK : Attack

@export var crouching_LP : Attack
@export var crouching_MP : Attack
@export var crouching_HP : Attack
@export var crouching_LK : Attack
@export var crouching_MK : Attack
@export var crouching_HK : Attack

@export var jumping_LP : Attack
@export var jumping_MP : Attack
@export var jumping_HP : Attack
@export var jumping_LK : Attack
@export var jumping_MK : Attack
@export var jumping_HK : Attack

var standing_control_dict = {"lp" : standing_LP, "mp" : standing_MP, "hp" : standing_HP}
var crouching_control_dict = {}
var jumping_control_dict = {}
