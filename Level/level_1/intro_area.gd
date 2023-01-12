extends Node2D

onready var size_of_map = get_node("camera_area/CollisionShape2D").shape
onready var camera = get_node("YSort/Charakter/Camera2D")

func _ready():
	var spawn = $Spawn.get_position()
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(spawn)
	player.set_position(spawn)