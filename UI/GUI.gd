extends CanvasLayer

# Expect the input and open the Game Menu or open the Character Sheet
# If the corresponding Menu is already open, it will be closed

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
			var character_sheet = load("res://Engine/CharacterSheet.tscn").instance()
			add_child(character_sheet)
		else:
			get_node("CharacterSheet").checkInv()
			get_node("CharacterSheet").queue_free()

# GUI still processes while sceneTree is paused

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

# instance the Options Menu and then open it 

func _on_Options_pressed():
	var options_menu = load("res://UI/OptionsMenu.tscn").instance()
	add_child(options_menu)
	var _options_connect = get_node("OptionsMenu").connect("CloseOptionsMenu", self, "CloseOptionsMenu")

# Closes the Options Menu

func CloseOptionsMenu():
	get_node("OptionsMenu").queue_free()

# Continue the Game

func _on_Continue_pressed():
	get_tree().paused = false
	get_tree().get_root().print_tree()
	get_node("GameMenu").hide()

# Exit the Game

func _on_ExitToDesktop_pressed():
	get_tree().quit()

# Reset attributes, scenechanger, charakter, inventory. 
# Then restarts with the intro scene

func _on_NewGame_pressed():
	get_tree().paused = false
	get_node('../YSort/Charakter/UiLayer').visible = true
	Attributes.reset()
	scenechanger.resetQuests()
	scenechanger.reset()
	scenechanger._reset()
	if get_node_or_null("../YSort/Charakter"):
		get_node("../YSort/Charakter").inventory.reset()
	scenechanger.goto_scene("res://Level/level_1/intro_area.tscn")
	#var _change_scene = get_tree().change_scene("res://Level/level_1/intro_area.tscn")

# Call the save function

func _on_Save_pressed():
	scenechanger.saveGame()

# Call the load function

func _on_Load_pressed():
	get_tree().paused = false
	get_node('../YSort/Charakter/UiLayer').visible = true
	scenechanger.loadGame()

# Call the Credit scene

func _on_Credits_pressed():
	get_tree().change_scene("res://UI/GodotCredits.tscn")
