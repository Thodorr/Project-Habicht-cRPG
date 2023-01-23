extends Node2D

export var border_left = 0
export var border_right = 1616
export var border_top = -160
export var border_bottom = 528


func _ready():
	var spawn = $Spawn.get_position()
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(spawn)
	player.set_position(spawn)
	$music.play()
