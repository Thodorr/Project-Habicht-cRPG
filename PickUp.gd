tool
extends Node2D

export(Resource) var item
export(int) var amount = 1
export(Texture) var replacement_image = null

export(int) var interaction_distance = 10
export var north_deactivated = false
export var east_deactivated = false
export var south_deactivated = false
export var west_deactivated = false

onready var sprite = get_node("Sprite")
onready var inventory = preload("res://Inventory.tres")
onready var player = get_parent().get_parent().get_node("YSort/Charakter")

var property_names: Array = []

func _ready():
	if replacement_image == null:
		sprite.texture = item.texture
	else:
		sprite.texture = replacement_image
	var _pick_up_finished_connect = player.connect("loot_anim_finished", self, "on_loot_anim_finished")

func on_loot_anim_finished():
	if $Interactable.moving_to_target == self:
		print(item)
		if item is Item:
			inventory.add_item(item, amount)
			if get_node("Interactable").hovering:
				player.mouse_mode = player.Mouse.REGULAR
			queue_free()

func _on_interaction_init():
	player.state = player.State.LOOTING

func _on_Interactable_mouse_entered():
	player.mouse_mode = player.Mouse.PICKUP

func _on_Interactable_mouse_exited():
	player.mouse_mode = player.Mouse.REGULAR
