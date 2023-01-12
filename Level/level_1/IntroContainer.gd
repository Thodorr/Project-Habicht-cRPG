extends Control

onready var noise = get_node("../../noise")
onready var music = get_node("../../music")

func _ready():
	que_intro()

func que_intro():
	var dialog = Dialogic.start("Intro")
	dialog.connect('dialogic_signal', self, '_end_intro')
	add_child(dialog)
	get_node("CanvasLayer").visible = true
	noise.play()
	if !noise.playing:
		noise.play()

func _end_intro(context):
	if context == 'end_intro':
		var dialog_node = get_child(2)
		remove_child(dialog_node)
		get_child(0).play("hide_black_screen")
		#que_end()

func que_end():
	get_child(0).play("hide_black_screen")
	var npc_1 = get_node("../../YSort/NPC2")
	#npc_pos1.set_position(Vector2(273, 217))
	var npc_1_position = npc_1.get_position()
	
	#TEST Start
	var tween = get_node("../../Tween")
	tween.interpolate_property(npc_1, "position",
		Vector2(npc_1_position), Vector2(273, 217), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	#TEST ENDE

	noise.stop()
	music.play()
	
	
	
