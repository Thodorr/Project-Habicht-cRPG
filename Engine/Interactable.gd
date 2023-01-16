tool
extends CollisionObject2D

signal interaction_init

onready var interactable : Node = owner
onready var character : KinematicBody2D = interactable.get_parent().get_parent().get_node("YSort/Charakter")
onready var positions = $Positions.get_children()

export(int) var interaction_distance = 10
export var north_deactivated = false
export var east_deactivated = false
export var south_deactivated = false
export var west_deactivated = false

var hovering : bool = false
var moving_to_target = null

func _ready():
	var nav_agent: NavigationAgent2D = character.get_node("NavigationAgent2D")
	var _mouse_entered_connect = connect("mouse_entered", self, "_on_mouse_entered")
	var _mouse_exited_conntect = connect("mouse_exited", self, "_on_mouse_exited")
	var _navigation_finished_connect = nav_agent.connect("navigation_finished", self, "_on_navigation_finished")
	var _path_changed_connect = nav_agent.connect("path_changed", self, "_on_path_changed")
	
	set_positions()

func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false

func _input(_event):
	if (!hovering): return
	if Input.is_action_just_pressed("left_mouse"):
		character.set_navigation(get_closest_position())
		moving_to_target = get_parent()

func _on_navigation_finished():
	if moving_to_target:
		var character_position = character.get_global_position()
		var dir = character_position.direction_to(get_global_position()).round()
		character.turn(dir)
		emit_signal("interaction_init")
		if get_parent() is KinematicBody2D:
			get_parent().turn(-dir)

func _on_path_changed():
	if (hovering): return
	moving_to_target = null

func get_closest_position():
	var shortest_distance = 99999 
	var closest_position = Vector2(0,0)
	
	for interaction_position in positions:
		var distance = interaction_position.get_global_position().distance_to(character.get_global_position())
		if shortest_distance > distance:
			shortest_distance = distance
			closest_position = interaction_position
	
	return closest_position.get_global_position()

func set_positions():
	var curr_axis = "x"
	var direction = interaction_distance
	for interaction_position in positions:
		if curr_axis == "x":
			interaction_position.position.x = direction
			interaction_position.position.y = 0
			curr_axis = "y"
		else:
			interaction_position.position.y = direction
			interaction_position.position.x = 0
			curr_axis = "x"
			direction = -direction
	
	if north_deactivated:
		positions.remove(3)
	if west_deactivated:
		positions.remove(2)
	if south_deactivated:
		positions.remove(1)
	if east_deactivated:
		positions.remove(0)
