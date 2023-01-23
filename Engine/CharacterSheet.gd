extends Control

onready var inventory = preload("res://Engine/Handler/Inventory.tres")
onready var player = get_node_or_null("../../YSort/Charakter")
onready var node_stat_points = get_node("Screen/Layout/Attributes/HBoxContainer/AvailablePoints/Label")
onready var path_main_stats = "Screen/Layout/Attributes/"
onready var path_active_quest_buttons = "Screen/Layout/Quests/ActiveQuests/QuestButtons/"
onready var path_done_quest_buttons = "Screen/Layout/Quests/DoneQuests/QuestButtons/"


var available_points = 0
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

# 1. Load the attributes from the attributes singelton
# 2. load the skills that have been unlocked to be visible and unlockable skills aswell 
# 3. Load active and done quests
# 4. connect all the buttons in the corresponding group to the corresponding function

func _ready():
	var _attributes_changed_connect = Attributes.connect("attributes_changed", self, "LoadStats")
	LoadStats()
	LoadSkills()
	LoadActiveOrDoneQuests(1)
	LoadActiveOrDoneQuests(2)
	node_stat_points.set_text("Points: "+ str(available_points))
	if available_points == 0:
		pass
	else:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.set_disabled(false)
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		button.connect("pressed", self, "IncreaseStat", [button.get_node("../..").get_name()])
	for button in get_tree().get_nodes_in_group("MinusButtons"):
		button.connect("pressed", self, "DecreaseStat", [button.get_node("../..").get_name()])
	for button in get_tree().get_nodes_in_group("SkillButtons"):
		button.connect("pressed", self, "TakeModul", [button.get_parent().get_name()])
	for button in get_tree().get_nodes_in_group("QuestButtons"):
		button.connect("pressed", self, "LoadQuestInfo", [button.get_parent().get_name()])

# Loads the attributes value into the Menu of Attributes 
# Sets the available skillpoints to the skillpoints managed in the attributes menu

func LoadStats():
	var keys = Attributes.Attribute.keys()
	var index = 0
	for key in keys:
		var key_name = key.capitalize()
		get_node(path_main_stats + key_name + "/StatBackground/Stats/Value").set_text(str(Attributes.get_attribute(index)))
		index +=1
	available_points = Attributes.skillpoint

# Enables the skills that have been unlocked already 
# Enables the skillbuttons for skills that are unlockable and can be learned
# Set the connectors between the learned skills to full value 
# Set the connectors to skills that can be obtained or learned to half value

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

# 1. sets the cache value up 
# 2. update the change value 
# 3. enable the decrease button for the stat
# 4. decrease available skillpoints and visually update
# 5. get current effective score 
# 6. if current effective score is maxscore disable the PlusButton of this particular skill
# 7. If no skillpoints are left disable all add buttons

func IncreaseStat(stat):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") + 1)
	get_node(path_main_stats + stat + "/StatBackground/Stats/Change").set_text("+" + str(get(stat.to_lower() + "_add")) + " ")
	get_node(path_main_stats + stat + "/StatBackground/Min").set_disabled(false)
	available_points -= 1
	node_stat_points.set_text("Points: " + str(available_points))
	var keys = Attributes.Attribute.keys()
	var index = 0
	for key in keys:
		if key.to_lower() == stat.to_lower():
			 break
		index += 1
	var maxScore = Attributes.attributes_base[index] + get(stat.to_lower() + "_add")
	if (maxScore >9 ):
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			if button.get_parent().get_parent().name == stat:
				button.set_disabled(true)
	if(available_points == 0):
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.set_disabled(true)

# 1. decrease cache value 
# 2. disable decrease button if cache value = 0
# 3. update change value
# 4. increase available skillpoints 
# 5. enable all Plusbuttons again, except for the attributes where the the effective maxscore is reached

func DecreaseStat(stat):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") -1 )
	if get(stat.to_lower() + "_add") == 0:
		get_node(path_main_stats + stat + "/StatBackground/Min").set_disabled(true)
		get_node(path_main_stats + stat + "/StatBackground/Stats/Change").set_text("")
	else:
		get_node(path_main_stats + stat + "/StatBackground/Stats/Change").set_text( "+" + str(get(stat.to_lower() + "_add")) + " ")
	available_points += 1
	node_stat_points.set_text("Points: " + str(available_points))
	var keys = Attributes.Attribute.keys()
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		var index = 0
		for key in keys:
			if key.to_lower() == button.get_parent().get_parent().name.to_lower():
				 break
			index += 1
		var maxScore = Attributes.attributes_base[index] + get(button.get_parent().get_parent().name.to_lower() + "_add")
		if(maxScore >9):
			button.set_disabled(true)
		else:
			button.set_disabled(false)

# 1. Basically set the corresponding skill in the charakter to true 
# 2. trigger connector animation 
# 3. after the connector animation start skill flare up animation 
# 4. Update all connectors so unlockable or obtainable skill connectors are loaded half way
# 5. modulate and enable the unlockable skills button now to show they are unlockable 

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
			if skill != "1A":
				tween1.interpolate_property(tween1.get_parent(), 'value', 50, 100, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
			tween2.interpolate_property(tween2.get_parent(), 'rect_scale', Vector2(1,1), Vector2(2.2, 2.2), 0.3, Tween.TRANS_QUART, Tween.EASE_OUT, 0.7)
			tween2.interpolate_property(tween2.get_parent(), 'rect_scale', Vector2(2.2, 2.2), Vector2(1, 1), 0.3, Tween.TRANS_QUART, Tween.EASE_IN, 1)
			if skill != "1A":
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

# 1. set the path to the quests accordingly to the active or done quests
# 2. Iterate over the quests directory
# 3. If a quests is aktive or done (determined in step 1) initialize the quest
# 4. for each quest: create new GUI Elements, especially the button with their name and 
# 	 connected function to show content  

func LoadActiveOrDoneQuests(AorD):
	var path_to_quest_buttons = path_active_quest_buttons
	if AorD == 2:
		path_to_quest_buttons = path_done_quest_buttons
	var dir = Directory.new()
	if dir.open("res://Units/Quests/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var quest = load("res://Units/Quests/"+ file_name)
				if quest.state == AorD:
					var margin = MarginContainer.new()
					margin.name = quest.questname
					margin.add_constant_override("margin_right", 10)
					margin.add_constant_override("margin_top", 5)
					margin.add_constant_override("margin_left", 10)
					margin.add_constant_override("margin_bottom", 5)
					margin.rect_size = Vector2(284,55)
					get_node(path_to_quest_buttons).add_child(margin)
					
					var questTrect = TextureRect.new()
					questTrect.name = quest.questname
					var texture = ResourceLoader.load("res://UI/Assets/GUI/QuestButton.tres")
					questTrect.texture = texture
					questTrect.expand = true
					questTrect.margin_left = 10
					questTrect.margin_top = 5
					questTrect.margin_right = 274
					questTrect.margin_bottom = 50
					questTrect.rect_size = Vector2(264,45)
					questTrect.rect_min_size = Vector2(0,45)
					questTrect.size_flags_horizontal = SIZE_EXPAND_FILL
					get_node(path_to_quest_buttons + quest.questname).add_child(questTrect)
					
					var questLabel = Label.new()
					questLabel.name = "QuestName"
					questLabel.text = quest.questname
					questLabel.anchor_left = 0.5
					questLabel.anchor_top = 0.5
					questLabel.anchor_right = 0.5
					questLabel.anchor_bottom = 0.5
					questLabel.margin_left = -120
					questLabel.margin_top = -20
					questLabel.margin_right = 120
					questLabel.margin_bottom = 20
					questLabel.rect_size = Vector2(240,40)
					questLabel.align = HALIGN_CENTER
					questLabel.valign = VALIGN_CENTER
					questLabel.size_flags_vertical = SIZE_SHRINK_CENTER
					get_node(path_to_quest_buttons + quest.questname + "/" + quest.questname).add_child(questLabel)
					
					var texturebutton = TextureButton.new()
					texturebutton.size_flags_horizontal = SIZE_EXPAND_FILL
					texturebutton.name = "TextureButton"
					texturebutton.add_to_group("QuestButtons", true)
					texturebutton.anchor_right = 1
					texturebutton.anchor_bottom = 1
					get_node(path_to_quest_buttons + quest.questname + "/" + quest.questname).add_child(texturebutton)
			file_name = dir.get_next()

# 1. Iterate over the quests and search the quest by name
# 2. instanciate the quest by their name 
# 3. get the QuestContent label 
# 4. set the Description in the QuestContent label to the quest Describtion until the current quest step
# 5. Hide active and done quests and show the quest content

func LoadQuestInfo(QuestName):
	var dir = Directory.new()
	if dir.open("res://Units/Quests/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var quest = load("res://Units/Quests/"+ file_name)
				if quest.questname == QuestName:
					var questDescriptionLabel = get_node("Screen/Layout/Quests/QuestContent/QuestInfoBackground/ScrollContainer/VBoxContainer/QuestInfo")
					questDescriptionLabel.text = ''
					for i in quest.step:
						questDescriptionLabel.text += quest.description[i] + '\n\n'
			file_name = dir.get_next()
	get_node("Screen/Layout/Quests/DoneQuests").hide()
	get_node("Screen/Layout/Quests/ActiveQuests").hide()
	get_node("Screen/Layout/Quests/QuestContent").show()

# as the reparent function

func reparent(child: Node, new_parent: Node):
	if child and new_parent:
		var old_parent = child.get_parent()
		old_parent.remove_child(child)
		new_parent.add_child(child)

# If the inventory is currently reparented to the Charakter Sheet, return it to the player

func checkInv():
	if get_node_or_null("Screen/Layout/UiLayer") != null:
		get_node("Screen/Layout/UiLayer").get_child(0).hide()
		reparent(get_node_or_null("Screen/Layout/UiLayer"), player)

# 1. write the cache values of the Attributes menu into the attributes singleton locking them in 
# 2. reset cache values
# 3. reload Stats
# 4. disable all decrease buttons 
# 5. reset all change labels

func _on_ConfirmButton_pressed():
	if athletics_add + dexterity_add + perception_add + persuasion_add + bluff_add + intimidation_add + knowledge_add + will_add + creativity_add  +luck_add == 0:
		print("Nothing to confirm - maybe add popup button")
	else: 
		Attributes.add_to_attribute(0,athletics_add)
		Attributes.add_to_attribute(1,dexterity_add)
		Attributes.add_to_attribute(2,perception_add)
		Attributes.add_to_attribute(3,persuasion_add)
		Attributes.add_to_attribute(4,bluff_add)
		Attributes.add_to_attribute(5,intimidation_add)
		Attributes.add_to_attribute(6,knowledge_add)
		Attributes.add_to_attribute(7,will_add)
		Attributes.add_to_attribute(8,creativity_add)
		Attributes.add_to_attribute(9,luck_add)
		athletics_add = 0
		dexterity_add = 0
		perception_add = 0
		persuasion_add = 0
		bluff_add = 0
		intimidation_add = 0
		knowledge_add = 0
		will_add = 0
		creativity_add = 0
		luck_add = 0
		Attributes.skillpoint = available_points
		LoadStats()
		for button in get_tree().get_nodes_in_group("MinusButtons"):
			button.set_disabled(true)
		for label in get_tree().get_nodes_in_group("ChangeLabels"):
			label.set_text("")

# Show Active Quests and hide done Quests and QuestContent

func _on_ActiveButton_pressed():
	get_node("Screen/Layout/Quests/QuestContent").hide()
	get_node("Screen/Layout/Quests/DoneQuests").hide()
	get_node("Screen/Layout/Quests/ActiveQuests").show()

# Show Done Quests and hide aktive Quests and QuestContent

func _on_DoneButton_pressed():
	get_node("Screen/Layout/Quests/QuestContent").hide()
	get_node("Screen/Layout/Quests/ActiveQuests").hide()
	get_node("Screen/Layout/Quests/DoneQuests").show()

# hide all other menues and show attributes menu
# call checkInv to return the inventory to the charakter

func _on_Stats_pressed():
	get_node("Screen/Layout/Skills").hide()
	get_node("Screen/Layout/Quests").hide()
	get_node("Screen/Layout/Attributes").show()
	get_node("Screen/Layout/Inventory").hide()
	checkInv()

# hide all other menues and show skills menu
# call checkInv to return the inventory to the charakter

func _on_Skills_pressed():
	get_node("Screen/Layout/Attributes").hide()
	get_node("Screen/Layout/Quests").hide()
	get_node("Screen/Layout/Skills").show()
	get_node("Screen/Layout/Inventory").hide()
	checkInv()

# hide all other menues and show quests menu
# call checkInv to return the inventory to the charakter

func _on_Quests_pressed():
	get_node("Screen/Layout/Attributes").hide()
	get_node("Screen/Layout/Skills").hide()
	get_node("Screen/Layout/Quests").show()
	get_node("Screen/Layout/Inventory").hide()
	checkInv()

# hide all other menues and show inventory menu
# reparents the inventory from the charakter to the charakter Sheet and shows it 

func _on_Inventory_pressed():
	get_node("Screen/Layout/Attributes").hide()
	get_node("Screen/Layout/Skills").hide()
	get_node("Screen/Layout/Quests").hide()
	reparent(get_node_or_null("../../YSort/Charakter/UiLayer"), get_node_or_null("Screen/Layout"))
	get_node("Screen/Layout/UiLayer").get_child(0).show()
	get_node("Screen/Layout/Inventory").show()

