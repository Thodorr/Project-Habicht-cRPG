extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("GameMenu"):
		print("im here")
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
func saveGame():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		
		if node.filename.empty():
			print("persisten node is not an instanced scene, skipped " + node.name)
			continue
		
		if !node.has_method("save"):
			print("persistent node is missing a save() function, skipped " + node.name)
			continue
		
		var node_data = node.call("save")
		
		save_game.store_line(to_json(node_data))
	save_game.close()

func loadGame():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		print("Error, we dont have a saved Game.")
		return 
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.get_parent().remove_child(i)
	
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		
		var new_object = load(node_data["filename"]).instance()
		new_object.add_to_group("Persist")
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i,node_data[i])
	save_game.close()

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


func _on_Save_pressed():
	saveGame()


func _on_Load_pressed():
	loadGame()
