extends KinematicBody2D

enum State {
	MOVING,
	IDLE,
	LOOTING,
	INTERACTING
}

onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

var may_move = false
var state = State.IDLE
var direction = Vector2(0,0)

func _ready():
	nav_agent.connect("velocity_computed", self, "_on_velocity_computed")
	animation_state.start("Idle")

func state_handler():
	if nav_agent.is_navigation_finished():
		state = State.IDLE

func animation_player():
	if state == State.MOVING:
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Walk/blend_position", direction)
		animation_state.travel("Walk")
	else: 
		animation_state.travel("Idle")


func _on_velocity_computed(velocity):
	state = State.MOVING
	move_and_slide(velocity)

func set_velocity(): 
	if nav_agent.is_navigation_finished():
		may_move = false
		return
	
	var targetpos: Vector2 = nav_agent.get_next_location()
	direction = global_position.direction_to(targetpos)
	var velocity: Vector2 = direction * nav_agent.max_speed
	nav_agent.set_velocity(velocity)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("left_mouse"):
		may_move = true
		nav_agent.set_target_location(get_global_mouse_position())

func _physics_process(_delta):
	if may_move:
		set_velocity()
		state_handler()
		animation_player()
