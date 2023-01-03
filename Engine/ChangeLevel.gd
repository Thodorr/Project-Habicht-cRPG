extends Node

var current_scene

func _ready():
	pass
	

func _on_Area2D_body_entered(_body):
	var node = get_name()
	var level = str ("res://Level/level_1/level_1_" , node , ".tscn")
	scenechanger.goto_scene(level)

