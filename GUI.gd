extends CanvasLayer


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

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
	if event.is_action_pressed("inventory"):
		if not has_node("CharacterSheet"):
			var character_sheet = load("res://CharacterSheet.tscn").instance()
			add_child(character_sheet)
			character_sheet._on_Inventory_pressed()
		else:
			get_node("CharacterSheet").checkInv()
			get_node("CharacterSheet").queue_free()
	if event.is_action_pressed("Attributes"):
		if not has_node("CharacterSheet"):
			var character_sheet = load("res://CharacterSheet.tscn").instance()
			add_child(character_sheet)
			character_sheet._on_Stats_pressed()
		else:
			get_node("CharacterSheet").checkInv()
			get_node("CharacterSheet").queue_free()
	if event.is_action_pressed("QuestMenu"):
		if not has_node("CharacterSheet"):
			var character_sheet = load("res://CharacterSheet.tscn").instance()
			add_child(character_sheet)
			character_sheet._on_Quests_pressed()
		else:
			get_node("CharacterSheet").checkInv()
			get_node("CharacterSheet").queue_free()
	if event.is_action_pressed("SkillMenu"):
		if not has_node("CharacterSheet"):
			var character_sheet = load("res://CharacterSheet.tscn").instance()
			add_child(character_sheet)
			character_sheet._on_Skills_pressed()
		else:
			get_node("CharacterSheet").checkInv()
			get_node("CharacterSheet").queue_free()

func saveGame():
	Dialogic.save()
	var save_game = File.new()
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var diaSave = Dialogic._get_definitions()
	var fileDic = {
		"filename" : "dialogic"
	}
	save_game.open("user://savegame.save", File.WRITE)
	diaSave.merge(fileDic)
	save_game.store_line(to_json(diaSave))
	save_game.store_line(to_json(scenechanger.saveScene()))
	save_game.store_line(to_json(Attributes.save()))
	save_game.store_line(to_json(saveQuests()))
	for node in save_nodes:
		if node.filename.empty():
			print("persisten node is not an instanced scene, skipped " + node.name)
			continue
		if !node.has_method("save"):
			print("persistent node is missing a save() function, skipped " + node.name)
			continue
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	if get_node_or_null("CharacterSheet"):
		get_node("CharacterSheet").checkInv()
	save_game.store_line(to_json(get_node("../YSort/Charakter").inventory.saveInv()))
	save_game.store_line(to_json(scenechanger.savePickUps()))
	save_game.close()

func saveQuests():
	var save_dict = {
		"filename" : "quests",
	}
	
	var dir = Directory.new()
	if dir.open("res://Units/Quests/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var quest = load("res://Units/Quests/"+ file_name)
				var array = [quest.state, quest.step]
				var quest_dict = {
					quest.questname : array
				}
				save_dict.merge(quest_dict, false)
			file_name = dir.get_next()
	return save_dict

func resetQuests():
	var dir = Directory.new()
	if dir.open("res://Units/Quests/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var quest = load("res://Units/Quests/"+ file_name)
				quest.state = 0
				quest.step = 0
			file_name = dir.get_next()

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
	resetQuests()
	scenechanger.reset()
	scenechanger._reset()
	if get_node_or_null("../YSort/Charakter"):
		get_node("../YSort/Charakter").inventory.reset()
	scenechanger.goto_scene("res://Level/level_1/intro_area.tscn")
	# var _change_scene = get_tree().change_scene("res://Level/level_1/intro_area.tscn")

func _on_Save_pressed():
	saveGame()

func _on_Load_pressed():
	get_tree().paused = false
	scenechanger.loadGame()


func _on_Credits_pressed():
	get_tree().change_scene("res://GodotCredits.tscn")
