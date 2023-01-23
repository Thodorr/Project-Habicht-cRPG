extends CanvasLayer

var fadeIn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_node("ColorRect/Tween")
	if fadeIn == true:
		tween.interpolate_property(tween.get_parent(), "modulate", Color(1,1,1,1), Color(1,1,1,0), 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else: 
		$ColorRect.color = Color(1, 1, 1, 1)
		get_node("ColorRect").visible = true
		tween.interpolate_property(tween.get_parent(), "modulate", Color(1,1,1,0), Color(1,1,1,1), 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		print(tween.is_inside_tree())
	var timer = Timer.new()
	timer.wait_time = 2
	timer.connect("timeout", self, "_on_timer_hideRect")
	timer.one_shot = true
	add_child(timer)
	tween.start()
	timer.start()


func _on_timer_hideRect():
	if fadeIn:
		get_node("ColorRect").visible = false
		self.queue_free()
	print("It failed.")
