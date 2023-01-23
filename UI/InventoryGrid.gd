extends GridContainer

onready var pathHolder = owner.get_child(0)
var inventory = preload("res://Engine/Handler/Inventory.tres")

func _ready():
	render_slots()
	inventory.connect("items_changed", self, "_on_items_changed")
	inventory.connect("row_added", self, "render_slots")

# Iterates through all the items in the inventory and calls the update_inventory_slot_display function for each item.
func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

# Updates the display of a specific inventory slot in the UI.
func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)

# Called whenever the items_changed signal is emitted by the inventory
# Takes a list of indexes as an argument and updates the display of the inventory slots at those indexes.
func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

# Displays the description of an item in the UI.
# Takes a slot_index as an argument and retrieves the item at that index from the items array of the inventory.
# If the item is an Item, its description is displayed in the UI. Otherwise, the description is set to an empty string.
func display_item_description(slot_index):
	var item = inventory.items[slot_index]
	var ItemDescribtion = pathHolder.itemDescription
	if item is Item:
		ItemDescribtion.bbcode_text = item.description
	else: 
		ItemDescribtion.bbcode_text = ""

# Called whenever the UI receives an input event that is not handled by any other function.
# In this case, it checks if the left mouse button was released.
# If so, checks if the drag_data variable of the inventory object is a Dictionary.
# If it is, it sets the item at the specified index in the items array to the item stored
# in the drag_data dictionary and sets the mouse mode to visible.
func _unhandled_input(event):
	if event.is_action_released("left_mouse"):
		if inventory.drag_data is Dictionary:
			var character = get_tree().get_current_scene().get_node('YSort/Charakter')
			var drop_position = character.get_global_mouse_position()
			if drop_position.distance_to(character.position) <= 25:
				var pickup = load("res://Engine/Placeables/PickUp.tscn")
				pickup = pickup.instance()
				pickup.set_global_position(character.get_global_mouse_position() + Vector2(5, 3))
				pickup.item = inventory.drag_data.item
				var map =  character.get_parent().get_parent()
				var pickup_container = map.get_node_or_null('PickUps')
				if pickup_container == null:
					var new_pickup_container = Node2D.new()
					new_pickup_container.add_child(pickup)
					map.add_child(new_pickup_container)
				else:
					map.get_node("PickUps").add_child(pickup)
			else:
				inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			inventory.drag_data = null

# Creates and displays inventory slots in the UI.
# It iterates through all the items in the items array of the inventory
# and creates an InventorySlot for each item.
func render_slots():
	for child in get_children():
		remove_child(child)
	for i in inventory.items:
		var slot = load("res://UI/InventorySlot.tscn").instance()
		add_child(slot)
	update_inventory_display()
