extends Resource
class_name Inventory

var drag_data = null

signal items_changed(indexes)
signal item_added(item, amount)
signal currency_changed(value)
signal row_added()

export(Array, Resource) var items = []
export var currency = 0

var hidden_items = []

var equipped_hat: Resource
var equipped_clothing: Resource
var equipped_hand: Resource 
var equipped_trinket: Resource 
var equipped_face: Resource

func _ready():
	make_items_unique()

func add_currency(value):
	currency += int(value)
	emit_signal("currency_changed", value)

# Adds items to the inventory.
# It takes an item and an amount as arguments and adds the specified number of copies of the item to the inventory.
# If the item already exists in the inventory, the amount of that item is increased, rather than adding a new item.
# The items_changed signal is emitted when the items in the inventory are modified.
func add_item(item: Resource, amount, readd = false):
	var index_counter = 0
	if !readd:
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

# Sets the item at a specific index in the items array to a new item.
func set_item(item_index, item):
	var previous_item = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previous_item

# Swaps the positions of two items in the items array. 
func swap_items(item_index, target_item_index):
	var target_item = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = target_item
	emit_signal("items_changed", [item_index, target_item_index])

# Removes an item from the inventory by first checking for its index.
# If it is found the the parameter amount is subtracted from items amount.
# If there is an item found with an amount of one or for some reason less, the item is removed. 
func remove_item(item: Resource, amount):
	var target_item_index = items.find(item)
	var item_found = target_item_index != -1
	if item_found:
		if item.amount > 1:
			item.amount -= amount
		elif item.amount == amount:
			items[target_item_index] = null
		else:
			items[target_item_index] = null
		emit_signal("items_changed", [target_item_index])
	return item_found

# Removes the item at a specific index in the items array.
func remove_item_at(item_index):
	var previous_item = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previous_item

# Checks if item is in the inventory
func check_for_item(item_name):
	for item in items:
		if item is Item:
			if item.name == item_name:
				return true
	return false

func find_item_by_name(item_name):
	for item in items:
		if item is Item:
			if item.name == item_name:
				return item
	return null

# Filters the items based on a type.
func filter_items(type = Item):
	add_hidden_items()
	var items_size = items.size()
	for i in items_size:
		if not items[i] is type && items[i] != null:
			hidden_items.append(items[i])
			items[i] = null
			emit_signal("items_changed", [i])

# Readds items that where filtered out
func add_hidden_items():
	for i in hidden_items.size():
		add_item(hidden_items[i], 1, true)
	hidden_items.clear()

# Creates copies of all the items in the items array, replacing the original references with the new copies.
# Doing this allows us to store the amount of the item in its resource, circumventing the clunky managing of dictionaries
# in the editor that are not predefined.
func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			 unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
		items = unique_items

# Uses item based on the item as a parameter
func use_item(item):
	var index = 0
	for target_item in items:
		if target_item is Item:
			if target_item == item:
				use_item_at(index)
		index += 1

signal item_equipped
signal open_popup

# Checks if the item has a text message associated with it and, if so, displays a pop-up with the message.
# It then removes the item from the inventory if it is marked as removable
# and adds any attributes associated with the item to the player character by calling
# the corresponding function of the Attribute script.
# If the item is an EquipmentItem, the item_equipped signal is emitted
# and the item is equipped in the appropriate slot, depending on its type.
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

# First saves every name of every equipped item 
# Second it creates a new dictionary with the saved variables
# It then iterates over the items and saves each name and amount 
# These will also be saved to a dictionary and the dictionary will then be merged
# Then the finaly dictionary will be returned

func saveInv():
	var hat = "nothing"
	var clothing = "nothing"
	var hand = "nothing"
	var trinket = "nothing"
	var face = "nothing"
	if equipped_hat != null:
		hat = equipped_hat.name
	if equipped_clothing != null:
		clothing = equipped_clothing.name
	if equipped_hand != null:
		hand = equipped_hand.name
	if equipped_trinket != null:
		trinket = equipped_trinket.name
	if equipped_face != null:
		face = equipped_face.name
	var save_dict = {
		"filename" : "inventory",
		"equipped_hat" : hat,
		"equipped_clothing" : clothing,
		"equipped_hand" : hand,
		"equipped_trinket" : trinket,
		"equipped_face" : face,
		"currency" : currency
	}
	for item in items:
		if item != null:
			var amount = 1
			if item.amount > 1:
				amount = item.amount
			var inventory_dict = {
				item.name : amount
			}
			save_dict.merge(inventory_dict, false)
	return save_dict

# 1. resets all Equipment and all items
# 2. It then iterates over all directory locations of items 
# 3. in each location it iterates over each item and checks if it is part of the loaded items 
# 	 If it is part of the loaded items it will be added to the inventory in the saved amount
# 	 it also checks if the item was saved in an equipment slot and set it to the slot if it was

func loadInv(node_data):
	equipped_hat = null
	equipped_clothing = null
	equipped_hand = null
	equipped_trinket = null 
	equipped_face = null
	for item in items:
		var amount = 1
		if item != null:
			if item.amount > 1:
				amount = item.amount
			remove_item(item,amount)
	var array = [
		"res://Units/Items/Equipment/Face/",
		"res://Units/Items/Equipment/Hat/",
		"res://Units/Items/Equipment/Outfit/",
		"res://Units/Items/Food/CategoryA/",
		"res://Units/Items/Food/CategoryB/",
		"res://Units/Items/Food/CategoryC/",
		"res://Units/Items/Other/",
		"res://Units/Items/TempItems/"
		]
	currency = node_data["currency"]
	emit_signal("currency_changed", node_data["currency"])
	for i in array.size():
		var dir = Directory.new()
		if dir.open(array[i]) == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if !dir.current_is_dir():
					var item = load(array[i]+ file_name)
					if item.name in node_data.keys():
						add_item(item, node_data[item.name], true)
					if item.name == node_data["equipped_face"]:
						equipped_face = item
						emit_signal("item_equipped", item)
					if item.name == node_data["equipped_hat"]:
						equipped_hat = item
						emit_signal("item_equipped", item)
					if item.name == node_data["equipped_clothing"]:
						equipped_clothing = item
						emit_signal("item_equipped", item)
					if item.name == node_data["equipped_hand"]:
						equipped_hand = item
						emit_signal("item_equipped", item)
					if item.name == node_data["equipped_trinket"]:
						equipped_trinket = item
						emit_signal("item_equipped", item)
				file_name = dir.get_next()

func checkEquip():
	if equipped_hat:
		emit_signal("item_equipped", equipped_hat) 
	if equipped_clothing:
		emit_signal("item_equipped", equipped_clothing)
	if equipped_hand:
		emit_signal("item_equipped", equipped_hand)
	if equipped_trinket:
		emit_signal("item_equipped", equipped_trinket) 
	if equipped_face:
		emit_signal("item_equipped", equipped_face)

# resets the items in the inventory and all equipment equipped

func reset():
	for item in items:
		var amount = 1
		if item != null:
			if item.amount > 1:
				amount = item.amount
			remove_item(item,amount)
	equipped_hat = null
	equipped_clothing = null
	equipped_hand = null
	equipped_trinket = null 
	equipped_face = null

func get_items():
	return items
