extends Node2D

var border_left = 0
var border_right = 1616
var border_top = 0
var border_bottom = 528

func _ready():
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(Vector2(280,100))
	player.set_position(Vector2(280,100))
	
