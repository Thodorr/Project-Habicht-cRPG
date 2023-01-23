extends Node2D

onready var inventory = preload("res://Inventory.tres")

export var border_left = 0
export var border_right = 500
export var border_top = 0
export var border_bottom = 549

func _ready():
	var initial_clothing = load("res://Units/Items/Equipment/Outfit/PurpleShirt.tres")
	inventory.add_item(initial_clothing, 1, true)
	inventory.use_item(initial_clothing)
	var spawn = $Spawn.get_position()
	var player = get_node("YSort/Charakter")
	player.nav_agent.set_target_location(spawn)
	player.set_position(spawn)
	$music.play()
