extends Item
class_name EquipmentItem

enum Type {
	HAT,
	CLOTHING,
	TRINKET,
	HAND,
	BACKPACK,
}

export(Type) var type = Type.CLOTHING
export(Texture) var sprite_sheet
