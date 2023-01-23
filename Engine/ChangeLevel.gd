extends Node

var level


func _on_Area2D_body_entered(_body):
	var node = get_name()
	level = str ("res://Level/level_1/level_1_" , node , ".tscn")
	var fadein = ResourceLoader.load("res://Level/level_1/Fading.tscn").instance()
	fadein.fadeIn = false
	get_tree().get_current_scene().add_child(fadein)
	var timer = Timer.new()
	timer.wait_time = 2.3
	timer.connect("timeout", self, "_on_timer_change_level")
	timer.one_shot = true
	add_child(timer)
	timer.start()


func _on_timer_change_level():
	scenechanger.goto_scene(level)
	

