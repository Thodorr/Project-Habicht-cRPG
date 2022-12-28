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


export (Array, Resource) var quest_item 
export (Array, Resource) var quest_reward

export (int) var reward_amount = 1
export (int) var amound_exp = 0

var step = 0
var quest_item_step = 0
var reward_item_step = 0

var state = Queststate.OPEN 


func start_quest(): 
	print ("Der State der Quest " , questname , " ist ", state) 
	if state == Queststate.OPEN: 
		state = Queststate.STARTED 
		print ("Der State der Quest " , questname , " ist ", state)
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
				get_item_reward()
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
		if step < description.size():
			print (description[step])
			step += 1
			get_item_reward()
		else:
			return
	else:
		return

func get_step():
	if step < description.size():
		print ("Sie befinden sich in Schritt: " , step , " der Quest!")
		return description[step]
	else:
		return step

func bring_quest():
	print("Bisher gefunden " , quest_item_step)
	if quest_item.size() > 0:
		state = Queststate.STARTED
		if quest_item_step < quest_item.size():
			print ("Benötigte Items ", quest_item.size(), " Sie haben: " , quest_item_step, " gefunden!")
			var check_item = inventory.remove_item(quest_item[quest_item_step], 1)
			if check_item == false:
				print ("Das Benötigte Item wurde noch nicht gefunden!")
			else:
				quest_item_step += 1
				get_item_reward()
		else:
			return
	else: 
		return


func get_item_step():
	if state != Queststate.DONE:
		if quest_item_step < quest_item.size():
			print ("Sie befinden sich in Schritt: " , quest_item_step , " der Quest!")
			return quest_item[quest_item_step]
		else:
			return quest_item_step
	else:
		var quest_done = "Quest ist beendet!"
		print (quest_done)
		return quest_done

func get_item_reward():
	if quest_reward.size() > 0:
		if reward_item_step < quest_reward.size(): 
			inventory.add_item(quest_reward[reward_item_step], reward_amount)
			print("Item! " , " Sie haben ein ", quest_reward[reward_item_step].name, " bekommen!")
			reward_item_step += 1 
		else:
			print ("Alle Belohnungen erhalten!")
	else: 
		print("No Item required!")
		

func handle_the_quest():
	if state != Queststate.DONE:
		if description.size() > 0:
			print ("hallo")
			if step < description.size():
				steps()
		if quest_item.size() > 0: 
			print("servus")
			if quest_item_step < quest_item.size():
				bring_quest()
		if description.size() == step && quest_item.size() == quest_item_step:
			end_quest()
	else:
		print ("Quest wurde beendet!")
		return 
