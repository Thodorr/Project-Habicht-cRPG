extends Node

var current_scene = null
var player = null
var keep_player = null


# Create an instance of the scene and add it to the current scene



func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)	

func goto_scene(path):
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	the_player()
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	current_scene.queue_free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	var new_scene = get_tree().get_root()
	var new_scene_y = current_scene.get_node("YSort")
	new_scene_y.add_child(keep_player)
	new_scene.add_child(current_scene)

func the_player():
	player = current_scene.get_node("YSort/Charakter")
	keep_player = player.duplicate()
	current_scene.remove_child(player)
