extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(Vector2(280,100))
	player.set_position(Vector2(280,100))
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
