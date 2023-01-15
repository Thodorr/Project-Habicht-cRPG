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

#String name of the quest
export(String) var questname = ""
#Bool variable is an item needed for completing the quest
export(bool) var item_needed = false
#Description of the tasks
export (Array, String, MULTILINE) var description 
#An array of items that the player has to bring to the npc 
export (Array, Resource) var quest_item 
#An array of  items the player recieves from completing a task or quest
export (Array, Resource) var quest_reward
# how much of an item the player gets from the task or quest
export (int) var reward_amount = 1
# how much experiance the player gains from the task or quest
export (int) var amound_exp = 0
#Step of the current task
var step = 0
#Step of the task which the player needs to bring to the npc
var quest_item_step = 0
#If the player has to do multiple tasks, 
#he gets multiple rewards, counts the step he is in
var reward_item_step = 0

#Begining stat of the quest is open, uses the enum
var state = Queststate.OPEN 
#Begining questtype is idle, type is set through dialoig 
var quest_questtype = Questtype.IDLE

#starts the quest, currently not in use 
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

#ends the quest
func end_quest():
	#just ends the quest, if the quest is state started,
	#an open or done quest can not closed again
	if state == Queststate.STARTED:
		if item_needed == true && quest_item_step == quest_item.size(): 
			inventory.add_item(quest_reward[reward_item_step], reward_amount)
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

#If the player decides to start the quest later
func start_quest_later():
	state = Queststate.OPEN

#Adds the gained experiance to the player
func add_exp():
	Attributes.add_to_experience(amound_exp)

#Looks for the Step of the task, is used when the player needs to go to an other npc
func steps(): 
	#Checks if there are any tasks
	if description.size() > 0:
		state = Queststate.STARTED
		if step < description.size():
			if step > 0:
				get_item_reward()
		else:
			get_item_reward()
#Returns the current step of the quest
func get_step():
	if step < description.size():
		return description[step]
	else:
		return step

func bring_quest():
	if quest_item.size() > 0:
		#Starts the quest 
		state = Queststate.STARTED
		#progresses while step is smaler then the task
		if quest_item_step < quest_item.size():
			#prevents the program from crashing if no item is placed in the array
			if quest_item[quest_item_step] == null:
				print("You have to place an item!")
			else:
				#check item removes the searched item and return null, if the item is not in inventory 
				#or proceedes
				var check_item = inventory.remove_item(quest_item[quest_item_step], 1)
				if check_item == false:
					return
				else:
					quest_item_step += 1
					if quest_item_step > 0:
						if step + quest_item_step != quest_reward.size():
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

func check_item_in_inventory():
	var check_item = inventory.remove_item(quest_item[quest_item_step], 1)
	if check_item == false:
		Dialogic.set_variable("check_item", "false")
	else:
		inventory.add_item(quest_item[quest_item_step], 1)
		Dialogic.set_variable("check_item", "true")
