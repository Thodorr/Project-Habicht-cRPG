extends Resource

class_name Quest

enum Queststate {
	OPEN,
	STARTED,
	DONE	
}

export(String) var questname = ""
export(String, MULTILINE) var description =""
export(bool) var item_needed = false
export (Resource) var quest_item 
export (Resource) var quest_reward
export (int) var reward_amount = 0

var state = Queststate.OPEN
