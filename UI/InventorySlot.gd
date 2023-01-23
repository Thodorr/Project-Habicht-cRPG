extends CenterContainer

var inventory = preload("res://Engine/Handler/Inventory.tres")

onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel

# Updates the display of the inventory slot. 
# It takes an item as an argument and sets the texture of
# the itemTextureRect UI element to the texture of the item.
# If the item has an amount greater than or equal to 2,
# the itemAmountLabel UI element is set to the amount of the item. Otherwise,
# the itemAmountLabel is set to an empty string. If the item object is not an Item,
# the itemTextureRect texture is set to null and the itemAmountLabel is set to an empty string.
func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
		if item.amount >= 2:
			itemAmountLabel.text = str(item.amount)
		else:
			itemAmountLabel.text = ""
	else:
		itemTextureRect.texture = null
		itemAmountLabel.text = ""

# Called when the inventory slot is dragged.
# It takes a _position argument and returns a Dictionary containing information about the item being dragged.
# The function retrieves the index of the inventory slot and
# removes the item at that index from the items array of the inventory.
# If the item is an Item, the TextureRect UI element is set to the item's texture and the mouse mode is set to hidden. 
# The set_drag_preview function is called to set a preview of the item being dragged.
# The drag_data variable of the inventory is set to the data dictionary and the data dictionary is returned.
func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item_at(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		return data

# Called to check if the inventory slot can accept a dropped item.
# It takes a _position and a data argument and returns true if the data is a Dictionary containing an item field.
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

# Called when an item is dropped on the inventory slot.
# It takes a _position and a data argument and swaps the item in the inventory slot with the dropped item.
# If the item in the inventory slot is the same type as the dropped item,
# the amount of the item in the inventory slot is increased by the amount of the dropped item. Otherwise,
# the items are swapped and the set_item function is called to set the item in the inventory slot to the dropped item.
# The drag_data variable of the inventory object is then set to null.
func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	
	if my_item is Item and my_item.name == data.item.name:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		my_item.amount += data.item.amount
		inventory.emit_signal("items_changed", [my_item_index])
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		inventory.swap_items(my_item_index, data.item_index)
		inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null

# Uses item on right click or double click
func _on_InventorySlotDisplay_gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			inventory.use_item_at(get_index())
		elif event.is_action_pressed("right_mouse"):
			inventory.use_item_at(get_index())

# Displays item infos on hover
func _on_InventorySlotDisplay_mouse_entered():
	var item = inventory.items[get_index()]
	if item == null: 
		hint_tooltip = ''
	else: 
		hint_tooltip = item.name + "\n" + item.description + attributes_to_string(item.item_attributes)
		if item.stress_relief > 0:
			hint_tooltip += "\n *Reliefs " + str(item.stress_relief) + " points of Stress*"

# Turn attributes to a formated string.
func attributes_to_string(attributes):
	var attribute_string = ''
	for attribute in attributes:
		if attributes[attribute] != 0:
			attribute_string += "\n"
			if attributes[attribute] > 0:
				attribute_string += "+"
			attribute_string += str(attributes[attribute]) + " " + Attributes.Attribute.keys()[attribute] 
	return attribute_string
