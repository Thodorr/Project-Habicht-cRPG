extends CenterContainer

var inventory = preload("res://Inventory.tres")

onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel

var food_eaten = 0
var food_timer = 0

func _process(_delta):
	if food_eaten >= 1:
		food_timer -= 1
		if food_timer <= 0:
			food_eaten -= 1

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

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

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

func _on_InventorySlotDisplay_gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			inventory.use_item_at(get_index())
		elif event.is_action_pressed("right_mouse"):
			inventory.use_item_at(get_index())

