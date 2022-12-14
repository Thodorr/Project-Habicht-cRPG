extends KinematicBody2D

enum State {
	MOVING,
	IDLE,
	LOOTING,
	INTERACTING
}

enum Mouse {
	REGULAR,
	PICKUP,
	NPC
}

signal loot_anim_finished

onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_tree: AnimationTree = $AnimationTree
onready var inventory = preload("res://Inventory.tres")
onready var animation_state = animation_tree.get("parameters/playback")
onready var ui_layer = $UiLayer
onready var timer = $Timer
onready var ripple = get_node("../Ripple")

onready var regular_cursor = preload("res://Assets/Cursors/Arrow.png")
onready var regular_cursor_clicked = preload("res://Assets/Cursors/Arrow_Clicked.png")
onready var hand_cursor = preload("res://Assets/Cursors/Hand.png")
onready var hand_cursor_clicked = preload("res://Assets/Cursors/Hand_Clicked.png")
onready var speech_cursor = preload("res://Assets/Cursors/Speech.png")
onready var speech_cursor_clicked = preload("res://Assets/Cursors/Speech_Clicked.png")

var may_navigate = false
var movement_blocked = false

var direction = Vector2(0,0)
var movement = Vector2(0,0)

var mouse_mode = Mouse.REGULAR

const ACCELERATION = 8

var skill_0A = true
var skill_1A = false
var skill_2A = false
var skill_3A = false
var skill_3B = false
var skill_3C = false
var skill_4A = false
var skill_4B = false
var skill_4C = false
var skill_5A = false
var skill_5B = false
var skill_5C = false

var unlockable_skills = []
var semester = 4

export var state = State.IDLE

func _ready():
	var _velocity_computed_connect = nav_agent.connect("velocity_computed", self, "_on_velocity_computed")
	var _item_equipped_connect = inventory.connect("item_equipped", self,"_on_item_equipped")
	animation_state.start("Idle")
	state = State.IDLE
	turn(Vector2(0, 1))
	unlockable_skills.append("1A")
	unlockable_skills.append("2A")
	unlockable_skills.append("3A")
	unlockable_skills.append("4A")

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"semester" : semester,
		"unlockable_skills" : unlockable_skills,
		"skill_1A" : skill_1A,
		"skill_2A" : skill_2A,
		"skill_3A" : skill_3A,
		"skill_3B" : skill_3B,
		"skill_3C" : skill_3C,
		"skill_4A" : skill_4A,
		"skill_4B" : skill_4B,
		"skill_4C" : skill_4C,
		"skill_5A" : skill_5A,
		"skill_5B" : skill_5B,
		"skill_5C" : skill_5C,
	}
	return save_dict

func animation_player():
	if state == State.MOVING:
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Walk/blend_position", direction)
		animation_tree.set("parameters/PickUp/blend_position", direction)
		animation_state.travel("Walk")
	elif state == State.LOOTING:
		animation_state.travel("PickUp")
	else:
		animation_state.travel("Idle")

func turn(turn_direction):
	animation_tree.set("parameters/Idle/blend_position", turn_direction)
	animation_tree.set("parameters/PickUp/blend_position", turn_direction)

func _on_navigation_finished():
	state = State.IDLE

func _on_NavigationAgent2D_target_reached():
	build_up = 1

func _on_velocity_computed(velocity):
	if(velocity.x <= 5 && velocity.x >= -5 && velocity.y <= 5 && velocity.y >= -5):
		state = State.IDLE
	else:
		state = State.MOVING
	var _motion = move_and_slide(velocity)

var nav_movement = Vector2(0,0)
var build_up = 1
func set_velocity(): 
	if nav_agent.is_navigation_finished():
		may_navigate = false
		return
	
	var targetpos: Vector2 = nav_agent.get_next_location()
	direction = global_position.direction_to(targetpos)

	if build_up <= nav_agent.max_speed:
		build_up += ACCELERATION - 2.5
	nav_movement = direction * build_up

	nav_agent.set_velocity(nav_movement)

func set_navigation(target):
	if movement_blocked: return
	timer.start()
	ripple.position = target
	ripple.frame = 0
	ripple.play("ripple")
	nav_agent.set_target_location(target)
	movement_blocked = true

func _unhandled_input(_event):
	if Input.is_action_pressed("left_mouse"):
		var min_dist = get_global_mouse_position().distance_to(position)
		if min_dist >= 10:
			may_navigate = true
			set_navigation(get_global_mouse_position())

func adapt_cursor():
	match(mouse_mode):
		Mouse.REGULAR:
			Input.set_custom_mouse_cursor(regular_cursor)
		Mouse.PICKUP:
			Input.set_custom_mouse_cursor(hand_cursor)
		Mouse.NPC:
			Input.set_custom_mouse_cursor(speech_cursor)
	if Input.is_action_pressed("left_mouse"):
		match(mouse_mode):
			Mouse.REGULAR:
				Input.set_custom_mouse_cursor(regular_cursor_clicked)
			Mouse.PICKUP:
				Input.set_custom_mouse_cursor(hand_cursor_clicked)
			Mouse.NPC:
				Input.set_custom_mouse_cursor(speech_cursor_clicked)

func _input(_event):
	var inventoryScene = ui_layer.get_child(0)
	if Input.is_action_just_pressed("inventory"):
		if !inventoryScene.visible:
			inventoryScene.visible = true
		else:
			inventoryScene.visible = false

func directional_input_handler():
	if movement_blocked: return Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		movement.y = max(movement.y - ACCELERATION, -nav_agent.max_speed)
		may_navigate = false
	elif Input.is_action_pressed("ui_down"):
		movement.y = min(movement.y + ACCELERATION, nav_agent.max_speed)
		may_navigate = false
	else:
		movement.y = lerp(movement.y, 0, 0.3)

	if Input.is_action_pressed("ui_right"):
		movement.x = min(movement.x + ACCELERATION, nav_agent.max_speed)
		may_navigate = false
	elif Input.is_action_pressed("ui_left"):
		movement.x = max(movement.x - ACCELERATION, -nav_agent.max_speed)
		may_navigate = false
	else:
		movement.x = lerp(movement.x, 0, 0.3)
	
	direction = movement.normalized()
	return movement

func _on_Timer_timeout():
	movement_blocked = false

func _pick_up_finished():
	emit_signal("loot_anim_finished")

func _on_item_equipped(item):
	match item.type:
		item.Type.HAT:
			$SpriteBundle/Hat.texture = item.sprite_sheet
		item.Type.CLOTHING:
			$SpriteBundle/Outfit.texture = item.sprite_sheet
		item.Type.BACK:
			$SpriteBundle/Back.texture = item.sprite_sheet


func _physics_process(_delta):
	adapt_cursor()
	var velocity = directional_input_handler()
	if velocity.x >= 0.1 || velocity.x <= -0.1 || velocity.y >= 0.1 || velocity.y <= -0.1:
		_on_velocity_computed(velocity)
	if may_navigate:
		set_velocity()
	animation_player()

