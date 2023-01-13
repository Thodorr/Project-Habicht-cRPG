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


export(Attribute) var type 
export(int) var difficulty = 10
export(Dictionary) var influences = {}

func get_influenced_difficulty():
	var influenced_difficulty = difficulty
	for influence in influences:
		influenced_difficulty -= influences[influence]
	
	return influenced_difficulty
