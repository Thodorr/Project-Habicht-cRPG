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
