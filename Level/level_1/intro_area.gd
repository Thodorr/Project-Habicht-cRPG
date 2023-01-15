extends Node2D

onready var size_of_map = get_node("camera_area/CollisionShape2D").shape
onready var camera = get_node("YSort/Charakter/Camera2D")

export var border_left = 0
export var border_right = 500
export var border_top = 0
export var border_bottom = 549

func _ready():
	var spawn = $Spawn.get_position()
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(spawn)
	player.set_position(spawn)
