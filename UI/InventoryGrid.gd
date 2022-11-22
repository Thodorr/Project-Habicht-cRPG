extends GridContainer

onready var pathHolder = owner.get_child(0)
var inventory = preload("res://Inventory.tres")

func _ready():
	render_slots()
	inventory.connect("items_changed", self, "_on_items_changed")
	inventory.make_items_unique()
	update_inventory_display()

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
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func render_slots():
	for i in inventory.items:
		var slot = load("res://UI/InventorySlot.tscn").instance()
		add_child(slot)
