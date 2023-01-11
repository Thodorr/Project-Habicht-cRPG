
extends Control


func _ready():
	que_intro()

func que_intro():
	var dialog = Dialogic.start("Intro")
	dialog.connect('dialogic_signal', self, '_end_intro')
	add_child(dialog)
	get_node("CanvasLayer").visible = true

func _end_intro(context):
	if context == 'end_intro':
		var dialog_node = get_child(2)
		remove_child(dialog_node)
		get_child(0).play("hide_black_screen")
		#que_end()

func que_end():
	print ("end intro")
	print (get_path())
	get_child(0).play("hide_black_screen")
	var npc_pos1 = get_node("../../YSort/NPC2")
	npc_pos1.set_position(Vector2(273, 217))
	#var music = get_node("../../Intromusic") 
	#music.play()

