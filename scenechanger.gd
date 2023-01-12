extends Node

var current_scene = null
var player = null
var keep_player = null
var keep_scene = null

var the_right_spawn = 0

var scenes = {} 



func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	the_player()
	state_of_scene()
	var stop = current_scene.get_node_or_null("music")
	if stop != null:
		stop.stop()
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	
	current_scene.queue_free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	
	var new_scene = get_tree().get_root()
	var new_scene_y = current_scene.get_node("YSort")
	
	new_scene_y.add_child(keep_player)
	new_scene.add_child(current_scene)
	
	spwanswitcher(current_scene.name)
	
	if scenes.has(current_scene.name) == true:
		var items_on_map = current_scene.get_node("PickUps")
		current_scene.remove_child(items_on_map)
		var from_dictionary = scenes[current_scene.name]
		current_scene.add_child(from_dictionary)


func the_player():
	player = current_scene.get_node("YSort/Charakter")
	keep_player = player
	player.get_parent().remove_child(player)
	
func state_of_scene():
	if current_scene.get_node_or_null("PickUps") == null:
		return
	else:
		keep_scene = current_scene.get_node("PickUps")
		var name_of_scene = current_scene.name
		scenes[name_of_scene] = keep_scene
		keep_scene.get_parent().remove_child(current_scene.get_node("PickUps"))

func spwanswitcher(name):
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
