extends Node

enum AttributeGroup {
	BODY,
	CHARACTER,
	MIND
}

var attribute_groups = {
	Attribute.ATHLETICS : AttributeGroup.BODY,
	Attribute.DEXTERITY: AttributeGroup.BODY,
	Attribute.PERCEPTION: AttributeGroup.BODY,
	
	Attribute.PERSUASION: AttributeGroup.CHARACTER,
	Attribute.BLUFF: AttributeGroup.CHARACTER,
	Attribute.INTIMIDATION: AttributeGroup.CHARACTER,
	
	Attribute.KNOWLEDGE: AttributeGroup.MIND,
	Attribute.WILL: AttributeGroup.MIND,
	Attribute.CREATIVITY: AttributeGroup.MIND,
}

var attribute_group_value = {
	AttributeGroup.BODY : 0,
	AttributeGroup.CHARACTER : 0,
	AttributeGroup.MIND : 0,
}

enum Attribute {
	ATHLETICS,
	DEXTERITY,
	PERCEPTION,
	
	PERSUASION,
	BLUFF,
	INTIMIDATION,
	
	KNOWLEDGE,
	WILL,
	CREATIVITY,
	
	LUCK
}

var attributes = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_base = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_equipment = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_hat = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_clothing = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_trinket = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_hand = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_face = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_temporary = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_food = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var attributes_extra = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	
	Attribute.PERSUASION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	
	Attribute.LUCK: 0,
}

var nerve = 0
var nerve_damage = 0

var skillpoint = 20
var experience = 0

func add_to_attribute(attribute, value):
	attributes_base[attribute] += value
	attribute_math()

func get_attribute(attribute):
	return attributes[attribute]
	
func get_attribute_group(attribute_group):
	return attribute_group_value[attribute_group]

func add_to_skillpoint(value):
	skillpoint += value

signal stressChanged(value)
func remove_stress(value):
	nerve_damage -= value
	if nerve_damage < 0:
		nerve_damage = 0
	emit_signal("stressChanged", value)
	if nerve_damage == nerve:
		death()

func death():
	var node = get_name()
	var start_screen = str ("res://StartScreen.tscn")
	var fadein = ResourceLoader.load("res://Level/level_1/Fading.tscn").instance()
	fadein.fadeIn = false
	get_tree().get_current_scene().add_child(fadein)
	var timer = Timer.new()
	timer.wait_time = 2.3
	timer.connect("timeout", self, "_on_timer_change_level", [start_screen])
	timer.one_shot = true
	add_child(timer)
	timer.start()


func _on_timer_change_level(level):
	scenechanger.goto_scene(level)

func remove_skillpoint(value):
	skillpoint -= value

func add_to_experience(value):
	if !value is int:
		value = int(value)
	
	experience += value

func level_up():
	add_to_skillpoint(1)
	experience -= 100
	
signal dice_rolled(dice)
func dice_roll():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var dice = rng.randi_range(1, 20)
	emit_signal("dice_rolled", dice)
	return dice

func do_check(checkName):
	var check = load("res://Units/Checks/" + str(checkName) + ".tres")
	do_check2(check)

func do_check2(check: Check):
	var result = attributes[check.type] + dice_roll()
	var success = result >= check.get_influenced_difficulty()
	if success:
		check.state = check.State.SUCCEEDED
	else:
		check.state = check.State.FAILED
	return result >= check.get_influenced_difficulty()

func get_probability(check: Check):
	var req_throw: float = get_required_roll(check)
	if (req_throw <= 0): return 100
	return (20 - req_throw) / 20 * 100

func get_required_roll(check: Check):
	return check.get_influenced_difficulty() - attributes[int(check.type)]

func get_attribute_for_dialog(attribute):
	print(attributes[int(attribute)])
	Dialogic.set_variable('AttributeValue', attributes[int(attribute)])

signal attributes_changed
func attribute_math():
	var attributegroup_bonus = 0
	var x = 0
	
	for i in attribute_group_value:
		attribute_group_value[i] = floor((attributes_base[i+x] + attributes_base[i+1+x] + attributes_base[i+2+x]) / 5 )
		x += 2
		if i == 2:
			x = 0
	
	for i in attributes_equipment:
		attributes_equipment[i] = attributes_hat[i] + attributes_clothing[i] + attributes_trinket[i] + attributes_hand[i] + attributes_face[i]
		
	for i in attributes:
		if i >= 0 && i <= 2:
			attributegroup_bonus = attribute_group_value[AttributeGroup.BODY]
		elif i >= 3 && i <= 5:
			attributegroup_bonus = attribute_group_value[AttributeGroup.CHARACTER]
		elif i >= 6 && i <= 8:
			attributegroup_bonus = attribute_group_value[AttributeGroup.MIND]
		else:
			attributegroup_bonus = 0
		attributes[i] = attributes_base[i] + attributes_equipment[i] + attributes_temporary[i] + attributes_food[i] + attributegroup_bonus + attributes_extra[i]
		
		if attributes[i] < 0:
			attributes[i] = 0
			
			
	nerve = 2 + attributes[Attribute.WILL]
	
	
#	if nerve_damage >= 1:
#		attributes_extra[Attribute.WILL] -= nerve_damage
#		nerve_damage = 0
#
#	if nerve_damage <= attributes[Attribute.WILL]:
#		attributes_extra[Attribute.WILL] = -nerve_damage
		
	emit_signal("attributes_changed")

signal clothingChanged
signal hatChanged
signal effectAdded
var temp_effects = []
var current_food = null
func add_item_stats(item):
	if item is EquipmentItem:
		match item.type:
			item.Type.HAT:
				for i in attributes_hat:
					attributes_hat[i] = item.item_attributes[i]
				emit_signal("hatChanged")
			item.Type.CLOTHING:
				for i in attributes_clothing:
					attributes_clothing[i] = item.item_attributes[i]
				emit_signal("clothingChanged")
			item.Type.TRINKET:
				for i in attributes_trinket:
					attributes_trinket[i] = item.item_attributes[i]
			item.Type.HAND:
				for i in attributes_hand:
					attributes_hand[i] = item.item_attributes[i]
			item.Type.FACE:
				for i in attributes_face:
					attributes_face[i] = item.item_attributes[i]
	elif item is TemporaryItem:
		var timer = Timer.new()
		timer.connect("timeout", self, "_on_timeout", [item])
		timer.one_shot = true
		add_child(timer)
		timer.start(item.effect_duration)
		
		for i in attributes_temporary:
			attributes_temporary[i] += item.item_attributes[i]
		temp_effects.append(item)
		emit_signal("effectAdded", [item])
	if item is FoodItem:
		current_food = item
		for i in attributes_food:
			attributes_food[i] = item.item_attributes[i]
	attribute_math()

func _on_timeout(item):
	for i in attributes_temporary:
		attributes_temporary[i] -= item.item_attributes[i]
	temp_effects.erase(item)
	attribute_math()

func save():
	var timer_dict = {}
	for children in get_children(): 
		var index = 0
		print(children.get_signal_connection_list("timeout")[0].binds[0].name )
		var my_dict = {
			"timeleft" + str(index) : children.time_left,
			"item" + str(index) : children.get_signal_connection_list("timeout")[0].binds[0].name
		}
		timer_dict.merge(my_dict,false)
		index += 1

	var attributes_base_array = []
	for key in attributes_base:
		attributes_base_array.append(attributes_base[key])

	var attributes_hat_array = []
	for key in attributes_hat:
		attributes_hat_array.append(attributes_hat[key])

	var attributes_clothing_array = []
	for key in attributes_clothing:
		attributes_clothing_array.append(attributes_clothing[key])

	var attributes_trinket_array = []
	for key in attributes_trinket:
		attributes_trinket_array.append(attributes_trinket[key])

	var attributes_face_array = []
	for key in attributes_face:
		attributes_face_array.append(attributes_face[key])

	var attributes_hand_array = []
	for key in attributes_hand:
		attributes_hand_array.append(attributes_hand[key])

	var attributes_temporary_array = []
	for key in attributes_temporary:
		attributes_temporary_array.append(attributes_temporary[key])

	var save_dict = {
		"filename" : "attributes",
		"skillpoint" : skillpoint,
		"attributes_base" : attributes_base_array,
		"attributes_hat" : attributes_hat_array,
		"attributes_clothing" : attributes_clothing_array,
		"attributes_trinket" : attributes_trinket_array,
		"attributes_face" : attributes_face_array,
		"attributes_hand" : attributes_hand_array,
		"attributes_temporary" : attributes_temporary_array,
		"nerve": nerve,
		"nerve_damage": nerve_damage
	}
	
	save_dict.merge(timer_dict, false)
	return save_dict

func load(node_data):
	var index = 0
	var arrayIndex = 1
	while index <9:
		attributes_base[index] = node_data["attributes_base"][arrayIndex]
		attributes_hat[index] = node_data["attributes_hat"][arrayIndex]
		attributes_clothing[index] = node_data["attributes_clothing"][arrayIndex]
		attributes_trinket[index] = node_data["attributes_trinket"][arrayIndex]
		attributes_face[index] = node_data["attributes_face"][arrayIndex]
		attributes_hand[index] = node_data["attributes_hand"][arrayIndex]
		attributes_temporary[index] = node_data["attributes_temporary"][arrayIndex]
		index += 1
		arrayIndex += 1
	skillpoint = node_data["skillpoint"]
	nerve = node_data["nerve"]
	nerve_damage = node_data["nerve_damage"]
	for i in node_data.keys():
		if "item" in i:
			var item = loadItem([node_data[i]])
			print(item)
			for k in attributes_temporary:
				attributes_temporary[k] += item.item_attributes[k]
			temp_effects.append(item)
			var timer = Timer.new()
			timer.connect("timeout", self, "_on_timeout", [item])
			timer.one_shot = true
			add_child(timer)
			timer.start(node_data["timeleft"+ str(i).trim_prefix("item")])
	attribute_math()

func loadItem(item):
	var result
	var dir = Directory.new() 
	if dir.open("res://Units/Items/TempItems/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var quest = load("res://Units/Items/TempItems/"+ file_name)
				if quest.name == item[0]:
					result = quest
			file_name = dir.get_next()
	return result

func reset():
	skillpoint = 0
	for item in temp_effects:
		_on_timeout(item)
	var i = 0
	while i <10 :
		attributes_base[i] = 0
		attributes_hat[i] = 0
		attributes_clothing[i] = 0
		attributes_trinket[i] = 0
		attributes_face[i] = 0
		attributes_hand[i] = 0
		i += 1
	attribute_math()
