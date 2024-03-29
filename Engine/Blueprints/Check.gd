extends Resource
class_name Check

enum Attribute {
	ATHLETICS,
	DEXTERITY,
	PERCEPTION,
	
	PERSUATION,
	BLUFF,
	INTIMIDATION,
	
	KNOWLEDGE,
	WILL,
	CREATIVITY,
	
	LUCK
}

enum State {
	OPEN,
	SUCCEEDED,
	FAILED
}

export var name = ''
export(Attribute) var type 
export(int) var difficulty = 10
export(Dictionary) var influences = {}
export var repeatable = false
var state = State.OPEN

# Returns the difficulty of the check after being effected by the influences
func get_influenced_difficulty():
	var influenced_difficulty = difficulty
	for influence in influences:
		influenced_difficulty -= influences[influence]
	
	return influenced_difficulty

# Adds an influence to the dictionary
func add_influence(influence: Dictionary):
	influences.merge(influence)
