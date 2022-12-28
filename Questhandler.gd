extends Resource 

class_name Questhandler

#Code From npc to store here:
#var questname
#var quest = load("res://Units/Quests/" + str(questname) + ".tres")

export(Array, Resource) var quests = []

func start_a_quest(questnamen, typeofquest):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.handle_the_quest(typeofquest)

func get_progress(questnamen): 
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.get_step()
