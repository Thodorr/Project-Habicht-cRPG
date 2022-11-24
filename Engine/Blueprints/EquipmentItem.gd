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

func ready():
	connect("use_item", self, "_on_item_used")

func _on_item_used():
	#add equip
	pass
