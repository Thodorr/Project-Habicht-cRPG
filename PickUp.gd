tool
extends Node2D

export(Resource) var item
export(int) var amount = 1

export(int) var interaction_distance = 10
export var north_deactivated = false
export var east_deactivated = false
export var south_deactivated = false
export var west_deactivated = false

onready var sprite = get_node("Sprite")
onready var inventory = preload("res://Inventory.tres")

var property_names: Array = []

func _ready():
	sprite.texture = item.texture

func _on_interaction_init():
	inventory.add_item(item, amount)
	queue_free()
