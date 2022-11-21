extends Resource
class_name Item

enum ItemAttribute {
	STRENGTH,
	ENDURANCE,
	INTUITION,
	LUCK,
	
	COORDINATION,
	PERCEPTION,
	SPEED,
	DEXTERITY
	
	DEMAGOGY,
	DECEPTION,
	INTIMIDATION,
	EMPATHY,
	
	KNOWLEDGE,
	WILL,
	CREATIVITY,
	ARGUMENTATION = -1
}

export(String) var name = ""
export(Texture) var texture
export(String, MULTILINE) var description =""
export(String, "clothing", "trinket", "hand", "potion", "food") var usage = "clothing";
export var item_attributes = {
	ItemAttribute.STRENGTH: 0,
	ItemAttribute.ENDURANCE: 0,
	ItemAttribute.INTUITION: 0,
	ItemAttribute.LUCK: 0,
	ItemAttribute.COORDINATION: 0,
	ItemAttribute.PERCEPTION: 0,
	ItemAttribute.SPEED: 0,
	ItemAttribute.DEXTERITY: 0,
	ItemAttribute.DEMAGOGY: 0,
	ItemAttribute.DECEPTION: 0,
	ItemAttribute.INTIMIDATION: 0,
	ItemAttribute.EMPATHY: 0,
	ItemAttribute.KNOWLEDGE: 0,
	ItemAttribute.WILL: 0,
	ItemAttribute.CREATIVITY: 0,
	ItemAttribute.ARGUMENTATION: 0,
}


var amount = 1
