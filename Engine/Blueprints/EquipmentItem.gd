extends Item
class_name EquipmentItem

enum Type {
	HAT,
	CLOTHING,
	TRINKET,
	HAND,
	BACK,
}

export(Type) var type = Type.CLOTHING
export(Texture) var sprite_sheet
