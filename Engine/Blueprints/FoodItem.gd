extends Item
class_name FoodItem

func ready():
	connect("use_item", self, "_on_item_used")

func _on_item_used():
	#add eat
	pass
