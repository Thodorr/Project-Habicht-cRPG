extends Resource

class_name Quest

var inventory = preload("res://Inventory.tres")


enum Queststate {
	OPEN,
	STARTED,
	DONE	
}

export(String) var questname = ""
#export(String, MULTILINE) var description =""
export(bool) var item_needed = false
export (Array, String, MULTILINE) var description 


export (Resource) var quest_item 
export (Resource) var quest_reward

export (int) var reward_amount = 1
export (int) var amound_exp = 0

var step = 0

var state = Queststate.OPEN 


func start_quest(): 
	if state == Queststate.OPEN: 
		state = Queststate.STARTED 
	if state == Queststate.DONE:
		print("This Quest can not be reopened!")


func end_quest():
	if state == Queststate.STARTED:
		if item_needed == true: 
			var check_item = inventory.remove_item(quest_item, 1)
			if check_item == null:
				print ("Das Benötigte Item wurde noch nicht gefunden!")
				state = Queststate.STARTED
			else:
				inventory.add_item(quest_reward, reward_amount)
		else:
			if quest_item == null:
				print("No quest item required!")
			else:
				if quest_reward == null:
					print("no item as reward")
					add_exp()
					state = Queststate.DONE
				else:
					inventory.add_item(quest_reward, reward_amount)
					add_exp()
					state = Queststate.DONE

func start_quest_later():
	state = Queststate.OPEN

func add_exp():
	Attributes.add_to_experience(amound_exp)
	print ("You gained ", amound_exp)

func steps(): 
	if description.size() > 0:
		state = Queststate.STARTED
		if step <= description.size():
			step += 1
		else:
			end_quest()
	else:
		start_quest()
