extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _ready():
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(Vector2(280,100))
	player.set_position(Vector2(280,100))
	$music.play()
