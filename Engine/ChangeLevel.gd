extends Node


func _ready():
	pass

func _on_Area2D_body_entered(_body):
	scenechanger.change_("res://Level/level_1/level_1_entrance.tscn")
