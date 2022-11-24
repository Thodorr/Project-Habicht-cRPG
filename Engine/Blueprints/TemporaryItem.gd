extends Item
class_name TemporaryItem

var effect_duration = 0

func ready():
	connect("use_item", self, "_on_item_used")

func _on_item_used():
	#add effect
	pass
