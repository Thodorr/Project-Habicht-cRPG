extends Resource 

class_name Questhandler

#Code From npc to store here:
#var questname
#var quest = load("res://Units/Quests/" + str(questname) + ".tres")

export(Array, Resource) var quests = []

func start_a_quest(questnamen):
	for thequest in quests: 
		if thequest.questname == questnamen:
			print(thequest.questname)
