tool
extends Node2D

#Handles the Quests

export(Array, Resource) var quest = []

signal thequest (quest, state)

# Called when the node enters the scene tree for the first time.

func start_quest(quest: Resource, state):
	state = "Started"
	emit_signal ("thequest", state)
	return state 

func check_quest(quest: Resource, state, item_needed):
	if item_needed == true: 
		var hallo = "hallo"
		return hallo


func end_quest(quest: Resource, state):
	state = "Done"
	emit_signal("thequest", state) 	
	return state


