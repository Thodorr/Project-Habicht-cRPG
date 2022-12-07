extends Control

onready var player = get_node("../../YSort/Charakter")
onready var node_stat_points = get_node("Screen/Layout/Attributes/HBoxContainer/AvailablePoints/Label")
onready var path_main_stats = "Screen/Layout/Attributes/"

var available_points = 2
var athletics_add = 0
var dexterity_add = 0
var perception_add = 0
var persuasion_add = 0
var bluff_add = 0
var intimidation_add = 0
var knowledge_add = 0
var will_add = 0
var creativity_add = 0
var luck_add = 0


# Get available stat points and Attributes out of the Player Node 

func _ready():
	LoadStats()
	LoadSkills()
	node_stat_points.set_text("Points: "+ str(available_points))
	if available_points == 0:
		pass
	else:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.set_disabled(false)

# ../.. == get_node Parent of Parent 
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		button.connect("pressed", self, "IncreaseStat", [button.get_node("../..").get_name()])
	for button in get_tree().get_nodes_in_group("MinusButtons"):
		button.connect("pressed", self, "DecreaseStat", [button.get_node("../..").get_name()])
	for button in get_tree().get_nodes_in_group("SkillButtons"):
		button.connect("pressed", self, "TakeModul", [button.get_parent().get_name()])
	
func LoadStats():
	# 9 = player.athletics
	get_node(path_main_stats + "Athletics/StatBackground/Stats/Value").set_text(str(9))

func LoadSkills():
	for skill in get_tree().get_nodes_in_group("Skills"):
		if player.get("skill_" + skill.get_name()) == true:
			get_node("Screen/Layout/Skills/SkillTree/TabContainer/IT/SkillTree/" 
						+ skill.get_name().left(1) + "/" + skill.get_name() + "/TextureButton").set_disabled(false)
		#enable skills that have been unlocked already
		elif player.get("skill_" + DataImport.skill_data[skill.get_name()].SkillUnlock) == true:
			if player.semester >= DataImport.skill_data[skill.get_name()].SkillSemester:
				for unlockable_skill in player.unlockable_skills:
					if skill.get_name() == unlockable_skill:
						var texture_button = get_node("Screen/Layout/Skills/SkillTree/TabContainer/IT/SkillTree/" 
						+ skill.get_name().left(1) + "/" + skill.get_name() + "/TextureButton")
						texture_button.set_disabled(false)
						texture_button.set_modulate(Color(0.4,0.4,0.4,1))
		#enable skills that meet the requirement, but havent been unlocked
	# load connectors
	for connector in get_tree().get_nodes_in_group("SkillConnectors"):
		if player.get("skill_" + connector.get_name()) == true:
			connector.value =100
		# load connectors for skills that have been unlocked
		elif player.get("skill_" + DataImport.skill_data[connector.get_name()].SkillUnlock) == true:
			if player.semester >= DataImport.skill_data[connector.get_name()].SkillSemester:
				connector.value = 50
		# load connectors halfway for skills that meet req- to unlock

func IncreaseStat(stat):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") + 1)
	get_node(path_main_stats + stat + "/StatBackground/Stats/Change").set_text("+" + str(get(stat.to_lower() + "_add")) + " ")
	get_node(path_main_stats + stat + "/StatBackground/Min").set_disabled(false)
	available_points -= 1
	node_stat_points.set_text("Points: " + str(available_points))
	if available_points == 0:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.set_disabled(true)
	
func DecreaseStat(stat):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") -1 )
	if get(stat.to_lower() + "_add") == 0:
		get_node(path_main_stats + stat + "/StatBackground/Min").set_disabled(true)
		get_node(path_main_stats + stat + "/StatBackground/Stats/Change").set_text("")
	else:
		get_node(path_main_stats + stat + "/StatBackground/Stats/Change").set_text( "+" + str(get(stat.to_lower() + "_add")) + " ")
	available_points += 1
	node_stat_points.set_text("Points: " + str(available_points))
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		button.set_disabled(false)

func TakeModul(skill):
		if player.get("skill_" + skill) == true:
			pass
		else:
			# visual feedback / unlock the skill
			var unlocking_skill = DataImport.skill_data[skill].SkillUnlock
			var connector_swimlane = str(unlocking_skill.left(1) + "to" + skill.left(1))
			var tween1 = get_node("Screen/Layout/Skills/SkillTree/TabContainer/IT/SkillsConnector/" 
			+ connector_swimlane + "/" + unlocking_skill + "/" + skill + "/Tween")
			var tween2 = get_node("Screen/Layout/Skills/SkillTree/TabContainer/IT/SkillTree/" + skill.left(1) + "/" + skill + "/TextureRect/Tween")
			# Tween 1 Takes 1 second, Tween 2 Wait 0.7 Second and then expanse over 0.3 seconds. After the 1 Second Tween 1 Takes and tween 2 is expanded
			# it start to inflate again, Tween 1 is dependent on tween 2 on the timing. 
			tween1.interpolate_property(tween1.get_parent(), 'value', 50, 100, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
			tween2.interpolate_property(tween2.get_parent(), 'rect_scale', Vector2(1,1), Vector2(2.2, 2.2), 0.3, Tween.TRANS_QUART, Tween.EASE_OUT, 0.7)
			tween2.interpolate_property(tween2.get_parent(), 'rect_scale', Vector2(2.2, 2.2), Vector2(1, 1), 0.3, Tween.TRANS_QUART, Tween.EASE_IN, 1)
			tween1.start()
			tween2.start()
			yield(get_tree().create_timer(1.3), "timeout")
			var texture_button = get_node("Screen/Layout/Skills/SkillTree/TabContainer/IT/SkillTree/" + skill.left(1) + "/" + skill + "/TextureButton")
			texture_button.set_modulate(Color(1, 1, 1, 1))
			player.set("skill_" + skill, true)
			var unlocked_skills = []
			for key in DataImport.skill_data.keys():
				if DataImport.skill_data[key].SkillUnlock == skill:
					if player.semester >= DataImport.skill_data[key].SkillSemester:
						unlocked_skills.append(key)
						connector_swimlane = str(skill.left(1) + "to" + key.left(1))
						var tween = get_node("Screen/Layout/Skills/SkillTree/TabContainer/IT/SkillsConnector/" + connector_swimlane + "/" + skill + "/" + key + "/Tween")
						tween.interpolate_property(tween.get_parent(), 'value', 0, 50, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
						tween.start()
			if not unlocked_skills == []:
				#yield here to let the last Tween finish before doing smth else
				yield(get_tree().create_timer(1),"timeout")
				for key in unlocked_skills:
					for unlockable_skill in player.unlockable_skills:
						if key == unlockable_skill:
							texture_button = get_node("Screen/Layout/Skills/SkillTree/TabContainer/IT/SkillTree/" + key.left(1) + "/" + key + "/TextureButton")
							texture_button.set_disabled(false)
							texture_button.set_modulate(Color(0.4, 0.4, 0.4, 1))

func _on_ConfirmButton_pressed():
	if athletics_add + dexterity_add + perception_add + persuasion_add + bluff_add + intimidation_add + knowledge_add + will_add + creativity_add  +luck_add == 0:
		print("Nothing to confirm - maybe add popup button")
	else: 
		# player.athletics += athletics_add
		# athlethic_add = 0
		LoadStats()
		for button in get_tree().get_nodes_in_group("MinusButtons"):
			button.set_disabled(true)
		for label in get_tree().get_nodes_in_group("ChangeLabels"):
			label.set_text("")

func _on_Stats_pressed():
	get_node("Screen/Layout/Attributes").show()
	get_node("Screen/Layout/Skills").hide()


func _on_Skills_pressed():
	get_node("Screen/Layout/Attributes").hide()
	get_node("Screen/Layout/Skills").show()
