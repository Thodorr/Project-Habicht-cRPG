extends GridContainer

onready var pathHolder = owner.get_child(0)
var inventory = preload("res://Inventory.tres")

func _ready():
	render_slots()
	inventory.connect("items_changed", self, "_on_items_changed")
	inventory.connect("row_added", self, "render_slots")
	inventory.make_items_unique()

func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)

func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

func display_item_description(slot_index):
	var item = inventory.items[slot_index]
	var ItemDescribtion = pathHolder.itemDescription
	if item is Item:
		ItemDescribtion.bbcode_text = item.description
	else: 
		ItemDescribtion.bbcode_text = ""

func _unhandled_input(event):
	if event.is_action_released("left_mouse"):
		if inventory.drag_data is Dictionary:
			var character = owner.owner
			var drop_position = character.get_global_mouse_position()
			if drop_position.distance_to(character.position) <= 25:
				var pickup = load("res://Engine/Placeables/PickUp.tscn")
				pickup = pickup.instance()
				pickup.set_global_position(character.get_global_mouse_position() + Vector2(5, 3))
				pickup.item = inventory.drag_data.item
				character.owner.get_node("PickUps").add_child(pickup)
			else:
				inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			inventory.drag_data = null

func render_slots():
	for child in get_children():
		remove_child(child)
	for i in inventory.items:
		var slot = load("res://UI/InventorySlot.tscn").instance()
		add_child(slot)
	update_inventory_display()
