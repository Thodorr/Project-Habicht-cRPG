extends KinematicBody2D


onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var may_move = false

func _ready():
	nav_agent.connect("velocity_computed", self, "_on_velocity_computed")

func _on_velocity_computed(velocity):
	move_and_slide(velocity)

func set_velocity(): 
	if nav_agent.is_navigation_finished():
		may_move = false
		return
	
	var targetpos: Vector2 = nav_agent.get_next_location()
	var direction: Vector2 = global_position.direction_to(targetpos)
	var velocity: Vector2 = direction * nav_agent.max_speed
	nav_agent.set_velocity(velocity)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("left_mouse"):
		may_move = true
		nav_agent.set_target_location(get_global_mouse_position())

func _physics_process(_delta):
	if may_move:
		set_velocity()
