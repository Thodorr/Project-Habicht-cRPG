extends Control

var inventory = preload("res://Inventory.tres")

func _ready():
	inventory.connect('currency_changed', self, '_on_currency_changed')
	_on_currency_changed()

func _on_currency_changed():
	$VBoxContainer/HBoxContainer2/TextureRect/Label.text = 'Currency: ' + str(inventory.currency)

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	inventory.set_item(data.item_index, data.item)

func _on_FilterButton_pressed(button_definer):
	var button_image = get_node("HBoxContainer/" + button_definer + "FilterButton/TextureRect")
	button_image.rect_position.y += 1

func _on_FilterButton_released(button_definer):
	var button_image = get_node("HBoxContainer/" + button_definer + "FilterButton/TextureRect")
	button_image.rect_position.y -= 1
	
	match(button_definer):
		"Equipment":
			inventory.filter_items(EquipmentItem)
		"Food":
			inventory.filter_items(FoodItem)
		"Temporary":
			inventory.filter_items(TemporaryItem)
		"Other":
			inventory.filter_items(OtherItem)
		_:
			inventory.filter_items()
