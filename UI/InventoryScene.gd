extends Control

var inventory = preload("res://Inventory.tres")

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	inventory.set_item(data.item_index, data.item)


func _on_Button_pressed():
	inventory.filter_items(EquipmentItem)


func _on_Allfilter_pressed():
	inventory.filter_items()


func _on_Temporaryfilter_pressed():
	inventory.filter_items(TemporaryItem)


func _on_Food_pressed():
	inventory.filter_items(FoodItem)
