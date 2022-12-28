extends KinematicBody2D

enum State {
	MOVING,
	IDLE,
	LOOTING,
	INTERACTING
}

signal loot_anim_finished

onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_tree: AnimationTree = $AnimationTree
onready var inventory = preload("res://Inventory.tres")
onready var animation_state = animation_tree.get("parameters/playback")
onready var player = owner.get_node("YSort/Charakter")

var questhandler = preload("res://Questhandler.tres")

var may_navigate = false
var movement_blocked = false

var direction = Vector2(0,0)
var movement = Vector2(0,0)
const ACCELERATION = 50 

export(Resource) var outfit = null
export(Resource) var body = null
export(Resource) var hair = null
export(Resource) var hat = null
export(String) var conversation = ""
export var state = State.IDLE

func _ready():
	var _velocity_computed_connect = nav_agent.connect("velocity_computed", self, "_on_velocity_computed")
	animation_state.start("Idle")
	state = State.IDLE
	turn(Vector2(0, 1))
	set_sprites()

func set_sprites():
	$SpriteBundle/Body.texture = body
	$SpriteBundle/Outfit.texture = outfit
	$SpriteBundle/Hair.texture = hair
	$SpriteBundle/Hat.texture = hat

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

func _on_velocity_computed(velocity):
	if(velocity.x <= 5 && velocity.x >= -5 && velocity.y <= 5 && velocity.y >= -5):
		state = State.IDLE
	else:
		state = State.MOVING
	var _motion = move_and_slide(velocity)

func set_velocity(): 
	if nav_agent.is_navigation_finished():
		may_navigate = false
		return
	
	var targetpos: Vector2 = nav_agent.get_next_location()
	direction = global_position.direction_to(targetpos)
	var velocity: Vector2 = direction * nav_agent.max_speed
	nav_agent.set_velocity(velocity)

func set_navigation(target):
	if movement_blocked: return
	nav_agent.set_target_location(target)
	movement_blocked = true

func _pick_up_finished():
	emit_signal("loot_anim_finished")

func _physics_process(_delta):
	if may_navigate:
		set_velocity()
	animation_player()

func _on_interaction_init():
	var dialog = Dialogic.start(conversation)
	add_child(dialog)
	


func _on_Interactable_mouse_entered():
	player.mouse_mode = player.Mouse.NPC


func _on_Interactable_mouse_exited():
	player.mouse_mode = player.Mouse.REGULAR
	
func start_quest(questname, questtype):
	questhandler.start_a_quest(questname, questtype)
	
func start_quest_laster():
	questhandler.start_quest_later()

func change_dialog(new_conversation):
	conversation = new_conversation
	


