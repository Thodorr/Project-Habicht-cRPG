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
			get_node("CharacterSheet").checkInv()
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
	get_tree().get_root().print_tree()
	get_node("GameMenu").hide()


func _on_ExitToDesktop_pressed():
	get_tree().quit()


func _on_NewGame_pressed():
	get_tree().paused = false
	Attributes.reset()
	scenechanger.resetQuests()
	scenechanger.reset()
	scenechanger._reset()
	if get_node_or_null("../YSort/Charakter"):
		get_node("../YSort/Charakter").inventory.reset()
	scenechanger.goto_scene("res://Level/level_1/intro_area.tscn")
	#var _change_scene = get_tree().change_scene("res://Level/level_1/intro_area.tscn")



func _on_Save_pressed():
	scenechanger.saveGame()


func _on_Load_pressed():
	get_tree().paused = false
	scenechanger.loadGame()
