extends Node2D

var border_left = -560
var border_right = 1088
var border_top = 0
var border_bottom = 368


func _ready():
	var spawn = $Spawn.get_position()
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(spawn)
	player.set_position(spawn)
	$music.play()

