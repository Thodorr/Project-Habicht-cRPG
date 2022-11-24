extends Resource
class_name Inventory

var drag_data = null

signal items_changed(indexes)
signal item_added(item, amount)

export(Array, Resource) var items = []

var equipped_clothing: Resource
var equipped_hand: Resource 
var equipped_trinket: Resource 

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
			else:
				var target_item_index = items.find(null)
				var has_space = target_item_index != -1
				if has_space:
					items[target_item_index] = item
					item.amount += amount - 1
					emit_signal("items_changed", [target_item_index])
				return has_space

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
	
func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			 unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
		items = unique_items	
