extends Resource

class_name Quest

onready var inventory = preload("res://Inventory.tres")

export(Array, Resource) var quests = []

enum Queststate {
	OPEN,
	STARTED,
	DONE	
}

export(String) var questname = ""
export(String, MULTILINE) var description =""
export(bool) var item_needed = false

export (Resource) var quest_item 
export (Resource) var quest_reward

export (int) var reward_amount = 1
export (int) var amound_exp = 0

var state = Queststate.OPEN 


func start_quest(): 
	if state == Queststate.OPEN: 
		state = Queststate.STARTED 


func end_quest():
	if state == Queststate.STARTED:
		if item_needed == true: 
			var check_item = inventory.remove_item(quest_item)
			if check_item == null:
				print ("Das Benötigte Item wurde noch nicht gefunden!")
			else:
				inventory.add_item(quest_reward, reward_amount)
		Attributes.add_to_experience(amound_exp)
		state = Queststate.DONE
