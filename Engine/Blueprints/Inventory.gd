extends Resource
class_name Inventory

var drag_data = null

signal items_changed(indexes)
signal item_added(item, amount)
signal row_added()

export(Array, Resource) var items = []

var hidden_items = []

var equipped_hat: Resource
var equipped_clothing: Resource
var equipped_hand: Resource 
var equipped_trinket: Resource 
var equipped_face: Resource

func add_item(item: Resource, amount):
	var index_counter = 0
	emit_signal("item_added", item, amount)
	
	for target_item in items:
		index_counter += 1
		if target_item is Item:
			if target_item.name == item.name:
				target_item.amount += amount
				index_counter -= 1
				emit_signal("items_changed", [index_counter])
				return true
			
	var target_item_index = items.find(null)
	var has_space = target_item_index != -1
	if has_space:
		items[target_item_index] = item
		item.amount += amount - 1
		emit_signal("items_changed", [target_item_index])
	else:
		var row = [null, null, null, null, null]
		items.append_array(row)
		emit_signal("row_added")
		add_item(item, amount)

func set_item(item_index, item):
	var previous_item = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previous_item

func swap_items(item_index, target_item_index):
	var target_item = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = target_item
	emit_signal("items_changed", [item_index, target_item_index])

func remove_item(item: Resource, amount):
	var target_item_index = items.find(item)
	var item_found = target_item_index != -1
	if item_found:
		if item.amount > 1:
			item.amount -= amount
		else:
			items[target_item_index] = null
		emit_signal("items_changed", [target_item_index])
	return item_found

func remove_item_at(item_index):
	var previous_item = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previous_item

func filter_items(type = Item):
	add_hidden_items()
	var items_size = items.size()
	for i in items_size:
		if not items[i] is type && items[i] != null:
			hidden_items.append(items[i])
			items[i] = null
			emit_signal("items_changed", [i])

func add_hidden_items():
	for i in hidden_items.size():
		add_item(hidden_items[i], 1)
	hidden_items.clear()
	print(hidden_items)

func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			 unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
		items = unique_items

func use_item(item):
	var index = 0
	for target_item in items:
		if target_item is Item:
			if target_item == item:
				use_item_at(index)
		index += 1

signal item_equipped
signal open_popup

func use_item_at(index):
	var item = items[index]
	if item == null: return
	
	if item.text_message != "" && !item.text_accepted:
		emit_signal("open_popup", item, item.accept_text, item.decline_text)
		return
	elif item.text_message != "" && item.text_accepted:
		item.text_accepted = false
	
	if item.removeable:
		if item.amount >= 2:
			item.amount -= 1
		else:
			remove_item_at(index)
		emit_signal("items_changed", [index])
	Attributes.add_item_stats(item)
	Attributes.remove_stress(item.stress_relief)
	
	if item is EquipmentItem:
		emit_signal("item_equipped", item)
		var prev_equip = null
		match item.type:
			0: 
				prev_equip = equipped_hat
				equipped_hat = item
			1: 
				prev_equip = equipped_clothing
				equipped_clothing = item
			2: 
				prev_equip = equipped_trinket
				equipped_trinket = item
			3: 
				prev_equip = equipped_hand
				equipped_hand = item
			4:
				prev_equip = equipped_face
				equipped_face = item

		if prev_equip != null:
			if items.find(item) > -1 || items.find(prev_equip) > -1:
				add_item(prev_equip, 1)
			else:
				set_item(index, prev_equip)

