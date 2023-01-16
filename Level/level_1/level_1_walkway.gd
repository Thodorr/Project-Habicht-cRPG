extends Node2D

var spawn

export var border_left = 0
export var border_right = 1616
export var border_top = 0
export var border_bottom = 528

func _ready():
	
	if scenechanger.the_right_spawn == 2: 
		spawn = $Spawn.get_position()
	else:
		spawn = $Spawn2.get_position()
	
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(spawn)
	player.set_position(spawn)
	$music.play()
