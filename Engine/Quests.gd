extends Resource

class_name Quest
# Preloads the inventory resource file
var inventory = preload("res://Engine/Handler/Inventory.tres")

# Enumeration for the state of the quest
# OPEN, STARTED, DONE
enum Queststate {
	OPEN,
	STARTED,
	DONE	
}
# Enumeration for the type of the quest
# TODO, BRING, IDLE
enum Questtype {
	TODO,
	BRING,
	IDLE
}
# Exported variable for the quest name
export(String) var questname = ""
# Exported variable for if an item is needed for the quest

export(bool) var item_needed = false

#Description of the tasks
export (Array, String, MULTILINE) var description 
# Exported variable for the description of the quest tasks
# Exported variable for the quest item required
export (Array, Resource) var quest_item 

# Exported variable for the quest reward

export (Array, Resource) var quest_reward

# how much of an item the player gets from the task or quest
export (int) var reward_amount = 1
# how much experiance the player gains from the task or quest
export (int) var amound_exp = 0
# Exported variable for the amount of money the player gains from the quest
export (int) var amount_money = 0
# Variable for the current step of the quest
var step = 1

var quest_item_step = 0
# Variable for the current step of the quest item

var reward_item_step = 0
# Variable for the current step of the quest reward
var state = Queststate.OPEN 

var quest_questtype = Questtype.IDLE

#NOT IN USE
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
# Function to finish the quest
func finish_quest():
		# check if the quest requires an item
	if item_needed == true:
				# check if the required item is in the inventory
		if inventory.check_for_item(quest_item[0].name):
						# remove the item from the inventory
			inventory.remove_item(quest_item[0], 1)
						# change the state to done

			state = Queststate.DONE
			#adds the experiance 
			Attributes.add_to_experience(amound_exp)
			#adds the aerned money to the inventory
			inventory.add_currency(amount_money)
			#adds the reward to the inventory
			get_item_reward()
		else:
			print('The required item is missing')
	else:
		#when no item is needed, get rewards
		state = Queststate.DONE
		Attributes.add_to_experience(amound_exp)
		inventory.add_currency(amount_money)
		get_item_reward()
		

#This code is for the end_quest() function of the Quest class in a role-playing game built with Godot. The function is called to end a quest that has been started by the player.
#The function first checks if the state of the quest is "STARTED" using an if statement. If the quest state is indeed "STARTED", it then checks if an item is needed for the quest to be completed and if the player has completed all the steps of the quest item. If both of these conditions are met, the function adds the quest reward to the player's inventory, calls the add_exp() function to add experience points to the player, and changes the quest state to "DONE".
#If the quest item is not needed or the player hasn't completed all the steps of the quest item, the function checks if there's any quest item required and if there's any quest reward. If there's no quest item or no quest reward, the function prints a message to the console and changes the quest state to "DONE", otherwise, it calls the get_item_reward() function and changes the quest state to "DONE".

func end_quest():
	if state == Queststate.STARTED:
		if item_needed == true && quest_item_step == quest_item.size(): 
			inventory.add_item(quest_reward[reward_item_step], reward_amount)
			add_exp()
			state = Queststate.DONE
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

#when a quest is started later
func start_quest_later():
	state = Queststate.OPEN
#adds experiance in the player
func add_exp():
	Attributes.add_to_experience(amound_exp)

#adds the step
func steps(): 
	if description.size() > 0:
		state = Queststate.STARTED

#gets the current task of the quest
func get_step():
	if step < description.size():
		return description[step]
	else:
		return step

#quest when the player has to bring an item to an npc
func bring_quest():
	#checks if there is a tast
	if quest_item.size() > 0:
		#sets quest to started
		state = Queststate.STARTED
		#are there any more steps?
		if quest_item_step < quest_item.size():
			#checks if there is an item in the quest itself
			if quest_item[quest_item_step] == null:
				print("You have to place an item!")
			else:
				#checks for the item in the inventpory and removes the item 
				var check_item = inventory.remove_item(quest_item[quest_item_step], 1)
				#when the item is not in inventory return
				if check_item == false:
					return
				else:
					#sets the counter higher, if there is another item to bring
					quest_item_step += 1
					if quest_item_step > 0:
						#gets reward for item
						if step + quest_item_step != quest_reward.size():
							get_item_reward()

#returns the item step
func get_item_step():
	if state != Queststate.DONE:
		if quest_item_step < quest_item.size():
			return quest_item[quest_item_step]
		else:
			return quest_item_step
	else:
		var quest_done = "Quest ist beendet!"
		return quest_done

#get the reward for the task
func get_item_reward():
	if quest_reward.size() > 0:
			inventory.add_item(quest_reward[reward_item_step], reward_amount)
			reward_item_step += 1

#what kind of quest is it and are there any tasks
func handle_the_quest(questtype):
	#checks questtype
	if questtype == "bring":
		quest_questtype = Questtype.BRING
	else:
		quest_questtype = Questtype.TODO
		#when quest is not finished go to steps
	if state != Queststate.DONE:
		if description.size() > 0 && quest_questtype == Questtype.TODO:
			if step <= description.size():
				steps()
		#when the task is bring go to bring_item
		if quest_item.size() > 0 && quest_questtype == Questtype.BRING: 
			if quest_item_step <= quest_item.size():
				bring_quest()
		#if the quest is done go to finish_quest
		if description.size() == step && quest_item.size() == quest_item_step: 
			end_quest()
	else:
		state = Queststate.DONE

#when you have to go to an npc, the npx itsels adds the step
func goto_npc(questtype):
	if questtype != "bring":
		step += 1
	else:
		quest_item_step += 1

#check if the item is in the invetory
func check_item_in_inventory():
	var check_item = inventory.remove_item(quest_item[int(quest_item_step)], 1)
	if check_item == false:
		Dialogic.set_variable("check_item", "false")
	else:
		inventory.add_item(quest_item[quest_item_step], 1)
		Dialogic.set_variable("check_item", "true")
