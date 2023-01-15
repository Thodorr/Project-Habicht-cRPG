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

func finish_quest(questnamen):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.finish_quest()

func get_progress(questnamen): 
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.get_step()

func get_progress_for_dialog(questname):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questname:
			Dialogic.set_variable('QuestStep', thequest.step)

func intermidiate(questnamen, questtype):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.goto_npc(questtype)

func check_quest_item(questnamen):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.check_item_in_inventory()

func advance_quest(questname):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questname:
			thequest.step += 1

func is_quest_active(questname):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questname:
			print(thequest.state)
			Dialogic.set_variable('questIsActive', thequest.state)
