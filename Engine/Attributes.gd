extends Node

enum AttributeGroup {
	BODY,
	CHARACTER,
	MIND
}

# Dictionary that maps attributes to their corresponding group
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

# Dictionary that stores the value of each attribute group
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

# Dictionary that stores the value of each attribute
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

# Dictionary that stores the base value of each attribute
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

# Dictionary that stores the value of attributes that come from equipment
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

# Dictionary that stores the value of attributes that come from hat
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

# Dictionary that stores the value of attributes that come from clothing
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

# Dictionary that stores the value of attributes that come from trinkets
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

# Dictionary that stores the value of attributes that come from hand
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

# Dictionary that stores the value of attributes that come from face
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

# Dictionary that stores the value of attributes that come from temporary items
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

# Dictionary that stores the value of attributes that come from food
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

# Dictionary that stores the value of attributes for additional options
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

# Initialize nerve and nerve_damge 
var nerve = 0
var nerve_damage = 0

# Initialize skillpoint and experience
var skillpoint = 20
var experience = 0

# Function to add a value to a specific attribute
func add_to_attribute(attribute, value):
	attributes_base[attribute] += value
	attribute_math()

# Function to get the value of a specific attribute
func get_attribute(attribute):
	return attributes[attribute]

# Function to get the value of a specific attribute group
func get_attribute_group(attribute_group):
	return attribute_group_value[attribute_group]

# Function to add a value to skillpoints
func add_to_skillpoint(value):
	skillpoint += value

# Signal emitted when stress changes used for UI updates
signal stressChanged(value)

# Function to remove stress
func remove_stress(value):
	nerve_damage -= value
	if nerve_damage < 0:
		nerve_damage = 0
	emit_signal("stressChanged", value)
	if nerve_damage == nerve:
		death()

# Function to handle death
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

# Handels scene change on death
func _on_timer_change_level(level):
	scenechanger.goto_scene(level)

# Reduces the skillpoint by the value provided as the parameter
func remove_skillpoint(value):
	skillpoint -= value

# Adds the value provided as the parameter to the experience.
func add_to_experience(value):
	if !value is int:
		value = int(value)
	
	experience += value

# Adds skill point and removes the experience needed for a level up
func level_up():
	add_to_skillpoint(1)
	experience -= 100

# Generates a random number between 1 and 20 and returns it
signal dice_rolled(dice)
func dice_roll():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var dice = rng.randi_range(1, 20)
	emit_signal("dice_rolled", dice)
	return dice

# Does a check based on a check name
func do_check(checkName):
	var check = load("res://Units/Checks/" + str(checkName) + ".tres")
	do_check2(check)

# Performs check based on a its resource
func do_check2(check: Check):
	var result = attributes[check.type] + dice_roll()
	var success = result >= check.get_influenced_difficulty()
	if success:
		check.state = check.State.SUCCEEDED
	else:
		check.state = check.State.FAILED
	return result >= check.get_influenced_difficulty()

# Returns the probability of success for the provided check
func get_probability(check: Check):
	var req_throw: float = get_required_roll(check)
	if (req_throw <= 0): return 100
	return (20 - req_throw) / 20 * 100

# Returns the required roll for the provided check
func get_required_roll(check: Check):
	return check.get_influenced_difficulty() - attributes[int(check.type)]

# Set the variable "attributeValue" in Dialogic to the value of the attribute
func get_attribute_for_dialog(attribute):
	Dialogic.set_variable('AttributeValue', attributes[int(attribute)])

# Updates the attributes based on various factors, such as equipment, temporary effects and food
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

# These signals are emited to update the corresponding UI
signal clothingChanged
signal hatChanged
signal effectAdded

# This variable stores the list of temporary items
var temp_effects = []
# This variable stores the current food item
var current_food = null
# Adds the attributes of the provided item to the corresponding attribute array
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
	
	# If the item is a TemporaryItem, a timer is created and added to the children list
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

# Called when the timer for a temporary effect times out
# The attributes of the temporary effect are removed from the attributes_temporary array
func _on_timeout(item):
	for i in attributes_temporary:
		attributes_temporary[i] -= item.item_attributes[i]
	temp_effects.erase(item)
	attribute_math()

# Saves the game state by creating a dictionary with various attributes
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

# loads the current attribute values from the saved data
# 1. iterates over the Enums, using index as the ENUM key to set the value 
# 2. sets skillpoints, nerve and nervedamage
# 3. iterates over the keys in node_data to start a timer for each saved timer with the corresponding time left
# 4. Then recalculates the attributes

func load(node_data):
	var index = 0
	var arrayIndex = 1
	while index <9:
		attributes_base[index] = node_data["attributes_base"][index]
		attributes_hat[index] = node_data["attributes_hat"][index]
		attributes_clothing[index] = node_data["attributes_clothing"][index]
		attributes_trinket[index] = node_data["attributes_trinket"][index]
		attributes_face[index] = node_data["attributes_face"][index]
		attributes_hand[index] = node_data["attributes_hand"][index]
		attributes_temporary[index] = node_data["attributes_temporary"][index]
		index += 1
		arrayIndex += 1
	skillpoint = node_data["skillpoint"]
	nerve = node_data["nerve"]
	nerve_damage = node_data["nerve_damage"]
	for i in node_data.keys():
		if "item" in i:
			var item = loadItem([node_data[i]])
			for k in attributes_temporary:
				attributes_temporary[k] += item.item_attributes[k]
			temp_effects.append(item)
			var timer = Timer.new()
			timer.connect("timeout", self, "_on_timeout", [item])
			timer.one_shot = true
			add_child(timer)
			timer.start(node_data["timeleft"+ str(i).trim_prefix("item")])
	attribute_math()

# iterates over the temporary items, instanciating each, and searches for a specifiy item by name
# when found it returns the instanced item 

func loadItem(item):
	var result 
	var dir = Directory.new() 
	if dir.open("res://Units/Items/TempItems/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var tempitem = load("res://Units/Items/TempItems/"+ file_name)
				if tempitem.name == item[0]:
					result = tempitem
			file_name = dir.get_next()
	return result

# resets all necessary variables for a new Game
# then recalculates the stats to remove every bonus

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
