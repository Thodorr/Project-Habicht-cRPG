extends Resource

class_name Quest

var inventory = preload("res://Inventory.tres")

# State of quest 
enum Queststate {
	OPEN,
	STARTED,
	DONE	
}
# Type of task 
enum Questtype {
	TODO,
	BRING,
	IDLE
}

export(String) var questname = ""

export(bool) var item_needed = false

export (Array, String, MULTILINE) var description 

export (Array, Resource) var quest_item 

export (Array, Resource) var quest_reward

# how much of an item the player gets from the task or quest
export (int) var reward_amount = 1
# how much experiance the player gains from the task or quest
export (int) var amound_exp = 0

var step = 0
var quest_item_step = 0
var reward_item_step = 0

var state = Queststate.OPEN 
var quest_questtype = Questtype.IDLE

func start_quest(): 
	if state == Queststate.OPEN: 
		state = Queststate.STARTED 
	if state == Queststate.DONE:
		print("This Quest can not be reopened!")
	if state == Queststate.STARTED:
		print("It is started! ", state)
		if item_needed == false && description.size() == 0 && quest_item.size() == 0:
			print("Nothing to see here!")
			state = Queststate.DONE 
		else:
			end_quest()

func end_quest():
	if state == Queststate.STARTED:
		if item_needed == true && quest_item_step == quest_item.size(): 
			get_item_reward()
			add_exp()
			state = Queststate.DONE
		else:
			print ("Something went very wrong!")
	else:
		if quest_item.size() == 0:
			print("No quest item required!")
		else:
			if quest_reward.size() == 0:
				print("no item as reward")
				add_exp()
				state = Queststate.DONE
			else:
				state = Queststate.DONE
				get_item_reward()
				add_exp()


func start_quest_later():
	state = Queststate.OPEN

func add_exp():
	Attributes.add_to_experience(amound_exp)

func steps(): 
	if description.size() > 0:
		state = Queststate.STARTED
		if step < description.size():
			if step > 0:
				get_item_reward()
		else:
			get_item_reward()

func get_step():
	if step < description.size():
		return description[step]
	else:
		return step

func bring_quest():
	if quest_item.size() > 0:
		state = Queststate.STARTED
		if quest_item_step < quest_item.size():
			if quest_item[quest_item_step] == null:
				print("You have to place an item!")
			else:
				var check_item = inventory.remove_item(quest_item[quest_item_step], 1)
				if check_item == false:
					return
				else:
					if quest_item_step > 0:
						get_item_reward()
		else:
			get_item_reward()

func get_item_step():
	if state != Queststate.DONE:
		if quest_item_step < quest_item.size():
			return quest_item[quest_item_step]
		else:
			return quest_item_step
	else:
		var quest_done = "Quest ist beendet!"
		return quest_done

func get_item_reward():
	if quest_reward.size() > 0:
		if quest_reward[reward_item_step] == null:
				print("You have to place an item!")
		else:
			if reward_item_step < quest_reward.size(): 
				inventory.add_item(quest_reward[reward_item_step], reward_amount)
				reward_item_step += 1 

func handle_the_quest(questtype):
	if questtype == "bring":
		quest_questtype = Questtype.BRING
	else:
		quest_questtype = Questtype.TODO
	if state != Queststate.DONE:
		if description.size() > 0 && quest_questtype == Questtype.TODO:
			if step <= description.size():
				steps()
		if quest_item.size() > 0 && quest_questtype == Questtype.BRING: 
			if quest_item_step <= quest_item.size():
				bring_quest()
		if description.size() == step && quest_item.size() == quest_item_step:
			end_quest()
	else:
		state = Queststate.DONE

func goto_npc(questtype):
	if questtype != "bring":
		step += 1
	else:
		quest_item_step += 1
