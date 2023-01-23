extends AnimatedSprite

onready var player = owner.get_node("YSort/Charakter")
export var destination = "res://Level/level_1/level_1_campus.tscn"

func _on_interaction_init():
	var fadein = ResourceLoader.load("res://Level/level_1/Fading.tscn").instance()
	fadein.fadeIn = false
	get_tree().get_current_scene().add_child(fadein)
	play("open")

func _on_Interactable_mouse_entered():
	player.mouse_mode = player.Mouse.PICKUP
	print(player.mouse_mode)

func _on_Interactable_mouse_exited():
	player.mouse_mode = player.Mouse.REGULAR


func _on_GlassDoor_animation_finished():
	scenechanger.goto_scene(destination)
