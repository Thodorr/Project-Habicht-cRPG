extends Resource
class_name Item

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

export(String) var name = ""
export(Texture) var texture
export(String, MULTILINE) var description =""
export var item_attributes = {
	Attribute.ATHLETICS: 0,
	Attribute.DEXTERITY: 0,
	Attribute.PERCEPTION: 0,
	Attribute.PERSUATION: 0,
	Attribute.BLUFF: 0,
	Attribute.INTIMIDATION: 0,
	Attribute.KNOWLEDGE: 0,
	Attribute.WILL: 0,
	Attribute.CREATIVITY: 0,
	Attribute.LUCK: 0,
}
export var removeable = true
var amount = 1
