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

func remove_stress(value):
	nerve_damage -= value
	if nerve_damage < 0:
		nerve_damage = 0

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

	var result = attributes[check.type] + dice_roll()
	
	if result >= check.difficulty:
		Dialogic.set_variable('Result', true)
	else:
		Dialogic.set_variable('Result', false)

func do_check2(check: Check):
	var result = attributes[check.type] + dice_roll()
	return result >= check.difficulty

func get_probability(check: Check):
	var req_throw: float = check.difficulty - attributes[check.type]
	if (req_throw <= 0): return 100
	return (20 - req_throw) / 20 * 100


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
	
	
	if nerve_damage >= 1:
		attributes_extra[Attribute.WILL] -= nerve_damage
		nerve_damage = 0
		
	if nerve_damage <= attributes[Attribute.WILL]:
		attributes_extra[Attribute.WILL] = -nerve_damage
		
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
