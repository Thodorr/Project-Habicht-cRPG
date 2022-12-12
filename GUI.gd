extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("GameMenu"):
		if get_node("GameMenu").visible == true:
			get_node("GameMenu").hide()
			get_tree().paused = false
		else:
			get_node("GameMenu").show()
			get_tree().paused = true
	if event.is_action_pressed("CharacterSheet"):
		if not has_node("CharacterSheet"):
			var character_sheet = load("res://CharacterSheet.tscn").instance()
			add_child(character_sheet)
		else:
			get_node("CharacterSheet").queue_free()


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Options_pressed():
	var options_menu = load("res://OptionsMenu.tscn").instance()
	add_child(options_menu)
	var _options_connect = get_node("OptionsMenu").connect("CloseOptionsMenu", self, "CloseOptionsMenu")

func CloseOptionsMenu():
	get_node("OptionsMenu").queue_free()

func _on_Continue_pressed():
	get_tree().paused = false
	get_node("GameMenu").hide()


func _on_ExitToDesktop_pressed():
	get_tree().quit()


func _on_NewGame_pressed():
	get_tree().paused = false
	var _change_scene = get_tree().change_scene("res://Testarea.tscn")
