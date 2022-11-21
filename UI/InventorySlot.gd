extends CenterContainer

var inventory = preload("res://Inventory.tres")

#onready var inventoryPathHolder = owner.owner.get_child(0)
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

#func use_item(item_definer):
#	var item
#
#	if item_definer is Item:
#		item = item_definer
#	else:
#		item = inventory.items[item_definer]
#
#	if item is Item:
#		match item.type:
#			"equipment":
#				equip_item(item_definer)
#				#Stats.add_item_stats(item)
#			"consumables":
#				consume_item(item)
#			"stuff":
#				pass

#func consume_item(item):
#	match item.usage:
#		"food":
#			if food_eaten <= 0:
#				food_eaten += 1
#				food_timer += 100
#				#Stats.add_item_stats(item)
#				#Stats.add_to_experience(1000)
#				inventory.remove_item(item, 1)
#		"potion":
#			inventory.remove_item(item, 1)
#			#Stats.add_item_stats(item)
#

#func equip_item(item_definer):
#	var item
#	var index_check = false
#	var previous_item = null
#	var previous_item_target
#
#	if item_definer is Item:
#		item = item_definer
#		index_check = false
#		previous_item_target = inventory.equipment_items.find(null)
#	else:
#		item = inventory.items[item_definer]
#		index_check = true
#		previous_item_target = item_definer
#
#	var equipContainer = inventoryPathHolder.equipmentContainer
#	match item.usage:
#		"clothing":
#			var clothing_slot = equipContainer.get_child(2)
#
#			if inventory.equipped_clothing != null:
#				previous_item = inventory.equipped_clothing
#				inventory.equipment_items[previous_item_target] = previous_item
#				inventory.emit_signal("items_changed", [previous_item_target])
#			inventory.equipped_clothing = item
#			clothing_slot.display_equipment(item)
#			#Stats.add_item_stats(item)
#			player_sprite.texture = item.sprite_sheet
#
#		"hand":
#			var hand_slot = equipContainer.get_child(1)
#
#			inventory.equipped_hand = item
#			hand_slot.display_equipment(item)
#
#		"trinket":
#			var trinket_slot = equipContainer.get_child(3)
#
#			inventory.equipped_trinket = item
#			trinket_slot.display_equipment(item)
#
#	if index_check == true:
#		inventory.equipment_items[item_definer] = previous_item
#		inventory.emit_signal("items_changed", [item_definer])
#		if previous_item != null:
#			previous_item = null


#func _on_InventorySlotDisplay_gui_input(event):
#	if event is InputEventMouseButton:
#		if event.is_action_released("click"):
#			get_parent().display_item_description(get_index())
#		elif event.doubleclick:
#			use_item(get_index())
#		elif event.is_action_pressed("right_click"):
#			use_item(get_index())

