extends Node2D

func _ready():
	var spawn = $Spawn.get_position()
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(spawn)
	player.set_position(spawn)
	$music.play()
