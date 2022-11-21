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
onready var ui_layer = $UiLayer
onready var timer = $Timer

var may_navigate = false
var movement_blocked = false
var state = State.IDLE
var direction = Vector2(0,0)

var movement = Vector2(0,0)
const ACCELERATION = 50 

func _ready():
	var _velocity_computed_connect = nav_agent.connect("velocity_computed", self, "_on_velocity_computed")
	animation_state.start("Idle")
	state = State.IDLE

func animation_player():
	if state == State.MOVING:
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Walk/blend_position", direction)
		animation_state.travel("Walk")
	else:
		animation_state.travel("Idle")

func turn(turn_direction):
	animation_tree.set("parameters/Idle/blend_position", turn_direction) 

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
	timer.start()
	nav_agent.set_target_location(target)
	movement_blocked = true

func _unhandled_input(_event):
	if Input.is_action_pressed("left_mouse"):
		may_navigate = true
		set_navigation(get_global_mouse_position())

func _input(_event):
	var inventoryScene = ui_layer.get_child(0)
	if Input.is_action_just_pressed("inventory"):
		if !inventoryScene.visible:
			inventoryScene.visible = true
		else:
			inventoryScene.visible = false

func wsad_input_handler():
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

func _physics_process(_delta):
	var velocity = wsad_input_handler()
	if velocity.x >= 0.1 || velocity.x <= -0.1 || velocity.y >= 0.1 || velocity.y <= -0.1:
		_on_velocity_computed(velocity)
	if may_navigate:
		set_velocity()
	animation_player()
