extends StaticBody2D

onready var player = owner.get_node("YSort/Charakter")
onready var inventory = preload("res://Engine/Handler/Inventory.tres")
export var destination = "res://Level/level_1/level_1_campus.tscn"
export var dialogName = 'StorageDoor'

func _on_interaction_init():
	if get_tree().get_current_scene().get_node_or_null("GUI/CharacterSheet"):
		var characterSheet = get_tree().get_current_scene().get_node("GUI/CharacterSheet")
		characterSheet.checkInv()
		characterSheet.queue_free()
	var dialog = Dialogic.start(dialogName)
	add_child(dialog)

func open_door():
	$AnimatedSprite.play("open")

func _on_Interactable_mouse_entered():
	player.mouse_mode = player.Mouse.PICKUP

func _on_Interactable_mouse_exited():
	player.mouse_mode = player.Mouse.REGULAR

func _on_Door_animation_finished():
	$CollisionShape2D.disabled = true

func check_for_item(item_name):
	Dialogic.set_variable('hasItem', inventory.check_for_item(item_name))
