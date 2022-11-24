extends Item
class_name TextItem

export(String, MULTILINE) var displayed_text = ""

func ready():
	connect("use_item", self, "_on_item_used")

func _on_item_used():
	#add opening textbox
	pass
