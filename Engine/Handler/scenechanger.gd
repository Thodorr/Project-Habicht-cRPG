extends Node

var current_scene = null
var player = null
var keep_player = null
var keep_scene = null

var the_right_spawn = 0

var scenes = {} 

func _ready():
	current_scene = get_tree().get_current_scene()

func goto_scene(path):
	var characterSheet = null
	if  get_parent().get_child(get_parent().get_child_count()-1).get_node_or_null("GUI/CharacterSheet"):
		characterSheet =  get_parent().get_child(get_parent().get_child_count()-1).get_node_or_null("GUI/CharacterSheet")
	if characterSheet:
		characterSheet.checkInv()
	var root = get_tree().get_root()
	current_scene = get_tree().get_current_scene()
	the_player()
	state_of_scene()
	var stop = current_scene.get_node_or_null("music")
	if stop != null:
		stop.stop()
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	
	var new_scene = ResourceLoader.load(path).instance()
	var new_scene_y = search_for_node(new_scene, "YSort")
	if keep_player:
		new_scene_y.add_child(keep_player)
	spawnswitcher(new_scene.name)
	
	if scenes.has(new_scene.name) == true:
		var items_on_map = search_for_node(new_scene, "PickUps") 
		items_on_map.name = items_on_map.name + str(1)
		new_scene.remove_child(items_on_map)
		var from_dictionary = scenes[new_scene.name]
		new_scene.add_child(from_dictionary)
	var fadein = ResourceLoader.load("res://Level/level_1/Fading.tscn").instance()
	new_scene.add_child(fadein)
	var root = get_tree().get_root()
	var old_scene = get_tree().get_current_scene()
	var old_parent = old_scene.get_parent()
	if old_scene and old_parent:
		old_parent.remove_child(old_scene)
		old_parent.add_child(new_scene)
		get_tree().set_current_scene(new_scene)
		old_scene.queue_free()
		new_scene_y.get_node("Charakter").set_camera()
	else:
		print("Error no root or current Scene")

# load the Game
# It is important to know that the scene that is loaded will be instanced
# The instanced scene will then be manipulated like the PickUps
# Then the Charakter will be added and set to the corresponding variable values 
# After the Charakter the inventory can be instanced and set to the loaded values
# Dialogic and the attributes aswell as the scenechanger do not follow an order
# Since these are autoload singletons, they are not dependent on anything in the current scene

# The Functions works by reading the SaveGame file, that is saved as a JSON 
# it then iterates over the lines of the JSON and uses the "filename" identifier to identify the owner of the data
# The owners load function will then be called and the data given to the load function seperately
# On the Charakter and NPCs there is no load function needed, and the variables saved will be set on the corresponding Nodes

# for a better understanding, please see the confluence documentation with the corresponding flow charts

func loadGame():
	var save_game = File.new()
	var loaded_scene 
	if not save_game.file_exists("user://savegame.save"):
		print("Error, we dont have a saved Game.")
		return 
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		if node_data != null:
			match node_data["filename"]:
				"dialogic":
					loadDialogic(node_data)
				"sceneChangerScene":
					loaded_scene = loadScene(node_data)
				"attributes":
					Attributes.load(node_data)
					Attributes.attribute_math()
				"quests":
					loadQuests(node_data)
				"checks":
					CheckHandler.loadChecks(node_data)
				"inventory":
					var charakter = search_for_node(loaded_scene,"Charakter")
					charakter.invCheck = true
					charakter.invContent = node_data
				"sceneChangerPickUps":
					loaded_scene = loadPickUps(loaded_scene, node_data)
				_:
					var save_nodes = []
					for node in loaded_scene.get_children():
						if node.has_node("Persist"):
							save_nodes.append(node)
					for i in save_nodes:
						i.get_parent().remove_child(i)
					var new_object = load(node_data["filename"]).instance()
					new_object.add_to_group("Persist")
					if search_for_node(loaded_scene, node_data["parent"]):
						search_for_node(loaded_scene, node_data["parent"]).add_child(new_object)
					new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
					for k in node_data.keys():
						if k == "filename" or k == "parent" or k == "pos_x" or k == "pos_y":
							continue
						new_object.set(k,node_data[k])
	var old_scene = get_tree().get_current_scene()
	var old_parent = old_scene.get_parent()
	if old_scene and old_parent:
		old_parent.remove_child(old_scene)
		old_parent.add_child(loaded_scene)
		get_tree().set_current_scene(loaded_scene)
		if old_scene != null:
			old_scene.queue_free()
	else:
		print("Error no root or current Scene")
	save_game.close()
	Dialogic.load()
	Dialogic.start('')

# The Function uses a SaveGame JSON File to store every nodes data to another line
# It is important to know that the order is important for loading the scene correctly,
# sinc some Componontes depend on other, e.g. PickUp Nodes need a map to be placed on before they can be loaded
# Some Components do not depend on others and can be saved and loaded in any order
# Every Components save function will be called and they all return a dictionary with the data that needs to be safed

# For a Better understanding look in the confluence documentation and see the corresponding flow charts

func saveGame():
	Dialogic.save()
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var diaSave = Dialogic._get_definitions()
	var fileDic = {
		"filename" : "dialogic"
	}
	diaSave.merge(fileDic)
	save_game.store_line(to_json(diaSave))
	save_game.store_line(to_json(scenechanger.saveScene()))
	save_game.store_line(to_json(Attributes.save()))
	save_game.store_line(to_json(saveQuests()))
	save_game.store_line(to_json(CheckHandler.save()))
	for node in save_nodes:
		if node.filename.empty():
			print("persisten node is not an instanced scene, skipped " + node.name)
			continue
		
		if !node.has_method("save"):
			print("persistent node is missing a save() function, skipped " + node.name)
			continue
		
		var node_data = node.call("save")
		
		save_game.store_line(to_json(node_data))
	if get_tree().get_current_scene().get_node_or_null("GUI/CharacterSheet"):
		get_tree().get_current_scene().get_node_or_null("GUI/CharacterSheet").checkInv()
	save_game.store_line(to_json(get_tree().get_current_scene().get_node("YSort/Charakter").inventory.saveInv()))
	save_game.store_line(to_json(scenechanger.savePickUps()))
	save_game.close()

# The function does the following:
# 1. load the questhandler
# 2. Create for each quest in the questhandler an array
# 3. Save the array to a dictionary 
# 4. merge the dicitonary with the save_dict 
# 5. return the full dictionary of quests

func saveQuests():
	var save_dict = {
		"filename" : "quests",
	}
	var questhandler = load("res://Engine/Handler/Questhandler.tres")
	for quest in questhandler.quests:
		if quest != null:
			var array = [quest.state, quest.step, quest.quest_item_step, quest.reward_item_step]
			var quest_dict = {
				get_ressource_name(quest) : array
			}
			save_dict.merge(quest_dict, false)
	return save_dict

# The function is needed for the saveQuests() function
# It simplyfies getting the resource name 

func get_ressource_name(resource: Resource):
	return resource.resource_path.get_file().trim_suffix('.tres')

# the reset quests function iterates over all quests and resets to factory settings

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

# This function sets the Dialogic variables to the safed values

func loadDialogic(node_data):
	var glossary = node_data["glossary"]
	var variables = node_data["variables"]
	for variable in variables:
		Dialogic.set_variable(variable.name, variable.value)

# This function loads the PickUps from the saved data
# 1. It removes the PickUp Node from the scene 
# 2. For each saved PickUp node it instances them 
# 3. It then adds them to the loaded(istanced) scene 
# 4. Then they will be written to the scenes[] array, 
#    so the scenechanger remembers all PickUp Node Configuration of all visited maps
# 5. It removes the PickUp node and continues with the for-loop
# 6. Then it sets the current PickUps needed for the current scene
# 7. The loaded and now manipulated scene that has the needed PickUps will be returned

func loadPickUps(loaded_scene, node_data):
	var index = 0
	var current_node = search_for_node(loaded_scene, "PickUps")
	# Remove PickUp Node if the loaded scene has one 
	if search_for_node(loaded_scene, "PickUps"):
		var node = search_for_node(loaded_scene, "PickUps")
		node.get_parent().remove_child(node)
	for key in node_data["keys"]:
		var packed_scene = ResourceLoader.load("res://Saves/" + key + ".scn")
		var new_node = packed_scene.instance()
		loaded_scene.add_child(new_node)
		scenes[key] = search_for_node(loaded_scene, "PickUps")
		if loaded_scene.name == key:
			current_node = new_node
			current_node.name = "PickUpsTrue"
		if search_for_node(loaded_scene, "PickUps"):
			var node = search_for_node(loaded_scene, "PickUps") 
			node.get_parent().remove_child(node)
	if current_node:
		current_node.name = "PickUps"
		current_node.get_parent().remove_child(current_node)
		loaded_scene.add_child(current_node)
	return loaded_scene

# The get_node() function is reserved for Nodes within the sceneTree
# This function acts as get_node() but for instanced scenes
# It is called multiple times throughout the loading of the scene
# It recursively calls itself to get the searched node 
# For a better understanding of recursive algorithms please referr to Prof. Dr. Gogol-Döring 

func search_for_node(instanced_scene, parent_node_name):
	var parent_node = null
	for node in instanced_scene.get_children():
		if node.get_name() == parent_node_name:
			parent_node = node
		if node.get_children():
			var children_node = null
			children_node = search_for_node(node, parent_node_name)
			if children_node:
				parent_node = children_node
	return parent_node

# This function loads the Quests
# 1. instance the questhandler
# 2. instance each quest 
# 3. set corresponding values in the quest
# 4. add quest to the array of loaded quests 
# 5. after all quests are loaded set questhandler questarray to the loadedQuests array

func loadQuests(node_data):
	var questhandler = load("res://Engine/Handler/Questhandler.tres")
	var loadedQuests = []
	for questname in node_data.keys():
		if questname == "filename":
			continue
		var questarray = node_data[questname]
		var quest = load("res://Units/Quests/" +questname + ".tres")
		quest.state = questarray[0]
		quest.step = questarray[1]
		quest.quest_item_step = questarray[2]
		quest.reward_item_step = questarray[3]
		loadedQuests.append(quest)
	questhandler.quests = loadedQuests

func the_player():
	player = get_tree().get_current_scene().get_node("YSort/Charakter")
	keep_player = player
	keep_player.get_parent().remove_child(keep_player)

func state_of_scene():
	if current_scene.get_node_or_null("PickUps") == null:
		return
	else:
		keep_scene = current_scene.get_node("PickUps")
		var name_of_scene = current_scene.name
		scenes[name_of_scene] = keep_scene
		keep_scene.get_parent().remove_child(current_scene.get_node("PickUps"))

# This function saves the PickUps
# 1. It adds the current configuration of PickUps to the scenes[] array of the scenechanger
# 2. remove current PickUps
# 3. iterate over all PickUps configurations and save them by scene name using the ResourceSaver
# 4. remove Pickups after each iteration 
# 5. Then adds the current PickUps to the Map again
# 6. Then saves all scenes keys so they can be loaded 
# 7. It then returns the dictionary with all scene keys

func savePickUps():
	current_scene = get_tree().get_current_scene()
	if current_scene.get_node_or_null("PickUps") == null:
		print ("No PickUps here!")
	else:
		keep_scene = current_scene.get_node("PickUps")
		scenes[current_scene.name] = keep_scene
	for key in scenes.keys():
		var packed_scene = PackedScene.new()
		var pickup_node = current_scene.get_node_or_null("PickUps")
		if(pickup_node):
			current_scene.remove_child(pickup_node)
		current_scene.add_child(scenes[key])
		if current_scene.get_node_or_null("PickUps"):
			for child in current_scene.get_node("PickUps").get_children():
				child.owner = current_scene.get_node("PickUps")
		if(current_scene.get_node_or_null("PickUps")):
			packed_scene.pack(current_scene.get_node("PickUps"))
			ResourceSaver.save("res://Saves/" + key + ".scn", packed_scene)
		if current_scene.get_node_or_null("PickUps"):
			pickup_node = current_scene.get_node_or_null("PickUps")
			current_scene.remove_child(pickup_node)
	if scenes.has(current_scene.name) :
		current_scene.add_child(scenes[current_scene.name])
		for child in current_scene.get_node("PickUps").get_children():
			child.owner = current_scene.get_node("PickUps")
	var save_dict = {
		"filename" : "sceneChangerPickUps",
		"keys" : scenes.keys()
	}
	return save_dict

# The function saves the name of the current scene so it can be loaded later
# It returns a dictionary

func saveScene():
	var save_dict = {
		"filename" : "sceneChangerScene",
		"currentScene" : get_tree().get_current_scene().name
	}
	return save_dict

# The functions instanciates the scene that shall be loaded 
# The old scene needs to be marked with an "Old" in the name as an identifier
# If the instanciated scene would be the same as the current scene Godot would change its name 
# That is done to help distinct them, but messes up the path to some nodes
# If the scene is the intro it stops the intro sequence

func loadScene(node_data):
	var level = str ("res://Level/level_1/level_1_" , node_data["currentScene"] , ".tscn")
	if node_data["currentScene"] == "intro_area":
		level = "res://Level/level_1/intro_area.tscn"
	if node_data["currentScene"] == get_tree().get_current_scene().name:
		get_tree().get_current_scene().name = get_tree().get_current_scene().name + "Old"
	var loaded_scene = ResourceLoader.load(level).instance()
	if node_data["currentScene"] == "intro_area":
		search_for_node(loaded_scene,"IntroContainer").loading = true
	return loaded_scene

# functions resets all memory of the scenechanger and altered scenes

func reset():
	for key in scenes.keys():
		scenes.erase(key)

# does the same as reset, but deferred

func _reset():
	call_deferred("reset")

func fetchNode(path):
	return get_node_or_null(path)

func spawnswitcher(name):
	match name:
		"campus": 
			the_right_spawn = 1
		"entrance":
			the_right_spawn = 2
		"walkway":
			the_right_spawn = 3
		"classroom":
			the_right_spawn = 4
		"examroom":
			the_right_spawn = 5
