extends KinematicBody2D

enum State {
	MOVING,
	IDLE,
	LOOTING,
	INTERACTING
}

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
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
export(Direction) var looking_dir = Direction.DOWN
export var state = State.IDLE

export(int) var interaction_distance = 15
export var north_deactivated = false
export var east_deactivated = false
export var south_deactivated = false
export var west_deactivated = false

var target_looking_dir = Vector2(0, 1)

func _ready():
	var _velocity_computed_connect = nav_agent.connect("velocity_computed", self, "_on_velocity_computed")
	animation_state.start("Idle")
	state = State.IDLE
	set_direction()
	set_sprites()
	set_interactable()

func set_interactable():
	$Interactable.interaction_distance = interaction_distance
	$Interactable.north_deactivated = north_deactivated
	$Interactable.east_deactivated = east_deactivated
	$Interactable.south_deactivated = south_deactivated
	$Interactable.west_deactivated = west_deactivated
	$Interactable.set_positions()

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

func move_to(target, result_dir):
	may_navigate = true
	nav_agent.set_target_location(target)
	target_looking_dir = result_dir

func _on_navigation_finished():
	state = State.IDLE
	turn(target_looking_dir)

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

func set_direction():
	var dir_vector
	match looking_dir:
		Direction.UP:
			dir_vector = Vector2(0,-1)
		Direction.DOWN:
			dir_vector = Vector2(0,1)
		Direction.LEFT:
			dir_vector = Vector2(-1,0)
		Direction.RIGHT:
			dir_vector = Vector2(1,0)
	turn(dir_vector)

func _pick_up_finished():
	emit_signal("loot_anim_finished")

func _physics_process(_delta):
	if may_navigate:
		set_velocity()
	animation_player()

func _on_interaction_init():
	if get_tree().get_current_scene().get_node_or_null("GUI/CharacterSheet"):
		var characterSheet = get_tree().get_current_scene().get_node("GUI/CharacterSheet")
		characterSheet.checkInv()
		characterSheet.queue_free()
	var dialog = Dialogic.start(conversation)
	add_child(dialog)

func _on_Interactable_mouse_entered():
	player.mouse_mode = player.Mouse.NPC

func _on_Interactable_mouse_exited():
	player.mouse_mode = player.Mouse.REGULAR

func give_item(itemFileName, type = 'Food', extraFolder = ''):
	var item = load("res://Units/Items/" + type + "/" + extraFolder + "/" + itemFileName + ".tres")
	inventory.add_item(item, 1)

func remove_item(item_name):
	inventory.remove_item(inventory.find_item_by_name(item_name), 1)

func give_money(amount):
	inventory.add_currency(amount)

func check_for_item(item_name):
	Dialogic.set_variable('hasItem', inventory.check_for_item(item_name))

func add_influence_to_check(check_name: String, influence_name, influence_value):
	var check: Check = CheckHandler.get_check_by_name(check_name)
	var influence : Dictionary = {influence_name: int(influence_value)}
	check.add_influence(influence)

func add_to_nerve(value):
	Attributes.remove_stress(int(value))

func finish_quest(questname):
	print(questname)
	questhandler.finish_quest(questname)

func get_quest_progress(questname):
	questhandler.get_progress_for_dialog(questname)

func advance_quest(questname):
	questhandler.advance_quest(questname)

func is_quest_active(questname):
	questhandler.is_quest_active(questname)

func start_quest(questname, questtype):
	questhandler.start_a_quest(questname, questtype)
	
func start_quest_laster():
	questhandler.start_quest_later()

func quest_intermidate(questname, questtype):
	questhandler.intermidiate(questname, questtype)

func change_dialog(new_conversation):
	conversation = new_conversation

func check_quest(questname):
	questhandler.check_quest_item(questname)
