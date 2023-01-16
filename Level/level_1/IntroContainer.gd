extends Control

onready var noise = get_node("../../noise")
onready var music = get_node("../../music")

var loading = false

func _ready():
	if !loading:
		que_intro()
	else: 
		get_child(0).play("hide_black_screen")
		loading = false

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
	#get_child(0).play("Walk_to_place")
	
	get_node("../../YSort/GroupMember1").move_to(Vector2(233, 217), Vector2(0, -1))
	get_node("../../YSort/GroupMember2").move_to(Vector2(253, 217), Vector2(0, -1))
	get_node("../../YSort/GroupMember3").move_to(Vector2(273, 217), Vector2(0, -1))
	get_node("../../YSort/ChillGuy").move_to(Vector2(293, 157), Vector2(0, -1))
	get_node("../../YSort/Charakter").move_to(Vector2(150, 157), Vector2(0, -1))
	get_node("../../YSort/Dozent").turn(Vector2(0, 1))
	get_node("../../YSort/T-Rex").turn(Vector2(0, -1))
	get_node("../../YSort/SleepyGuy").turn(Vector2(0, -1))
	
	get_node("../../YSort/Charakter").move_to(Vector2(150, 157), Vector2(0, -1))
	
	get_node("../../YSort/Blocker1").move_to(Vector2(180, 270), Vector2(0, -1))
	get_node("../../YSort/Blocker2").move_to(Vector2(200, 270), Vector2(0, -1))
	get_node("../../YSort/Blocker3").move_to(Vector2(160, 270), Vector2(0, -1))
	#npc_pos1.set_position(Vector2(273, 217))

	noise.stop()
	music.play()
	
	
	
