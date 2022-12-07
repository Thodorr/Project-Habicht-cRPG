#extends Node2D
#
#var totalNumberOfSkills = 4
#var totalNumberOfValuesPerSkill = 3
#var skillArray =  []
#
#for x in range(totalNumberOfSkills):
#	skillArray.append([])
#	skillArray[x] = []
#	for y in range(totalNumberOfValuesPerSkill):
#		skillArray.append([])
#		skillArray[x][y] = 0;
#
#
##check if no saved game exists, if there is none, create values
#
##Skill 1
#skillArray[0][0] = "Fingerfertigkeit"
#skillArray[0][1] = "dieser skill macht dich beim fingern fertig"
#skillArray[0][2] = 0 
#skillArray[0][3] = 10
#
##SKill 2
#skillArray[0][0] = "Athletik"
#skillArray[0][1] = "dieser skill macht dich schneller und resistenter gegen alk"
#skillArray[0][2] = 0
#skillArray[0][3] = 10
#
##SKill 3
#skillArray[0][0] = "luck"
#skillArray[0][1] = "dieser skill macht dich lucky"
#skillArray[0][2] = 0
#skillArray[0][3] = 10
#
##if sg exists, use saved values for skill array
##read character values and store to array
#
#func _increaseSkillValue(int internalSkillID):
#	if (skillArray[internalSkillID][2] <= maxSkillValue && character.availableSkillPoints >= 1):
#		skillArray[internalSkillID][2] +=  1
#		character.availableSkillPoints -= 1
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#0
