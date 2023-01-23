extends Resource 

class_name Questhandler


export(Array, Resource) var quests = []

# Function to start a quest
func start_a_quest(questnamen, typeofquest):
		# Iterate through all the quests in the game
			# If the quest is null, return
			# If the quest name matches the passed in quest name

	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
						# Call the handle_the_quest function on the quest
			thequest.handle_the_quest(typeofquest)
# Function to finish a quest
func finish_quest(questnamen):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.finish_quest()

#get progress of the quest
func get_progress(questnamen): 
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.get_step()
#get the progress for the dialog in dialogic
func get_progress_for_dialog(questname):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questname:
			Dialogic.set_variable('QuestStep', thequest.step)

#add the quest step by 1, when the player talked to a npc
func intermidiate(questnamen, questtype):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.goto_npc(questtype)

#checks if the player has the item for the quest
func check_quest_item(questnamen):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questnamen:
			thequest.check_item_in_inventory()
#the next task in the quest
func advance_quest(questname):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questname:
			thequest.step += 1
#checks if the quest is active, or done
func is_quest_active(questname):
	for thequest in quests: 
		if thequest == null: 
			return
		if thequest.questname == questname:
			Dialogic.set_variable('questIsActive', thequest.state)
