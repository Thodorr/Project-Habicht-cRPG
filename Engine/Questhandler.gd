extends Resource
class_name Questhandler

#Handles the Quests

export(Array, Resource) var quests = []

signal queststate (quest, state)

# Called when the node enters the scene tree for the first time.

func start_quest(quest: Resource, state):
	if state != "Open":
		state = Quest.Queststate.STARTED
		emit_signal ("queststate", quest, state)	
	return state 

func end_quest(quest: Resource, state):
	if state != "Done":
		state = Quest.Queststate.DONE
		emit_signal("queststate", quest, state) 	
		#var reward = Quest.quest_reward
		#var amount = Quest.reward_amount
		#add_item(reward, amount)
	return state


