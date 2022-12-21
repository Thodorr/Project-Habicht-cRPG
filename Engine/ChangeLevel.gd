extends Control


func _ready():
	pass

func _on_Button_pressed():
	scenechanger.goto_scene("res://Level/level_1/level_1_entrance.tscn")
