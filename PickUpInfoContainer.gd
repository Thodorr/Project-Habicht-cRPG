extends VBoxContainer


onready var inventory = preload("res://Inventory.tres")
onready var font = preload("res://UI/Font/PixelFontSmall.tres")

func _ready():
	var _item_added_connect = inventory.connect("item_added", self, "_on_item_added")
	var _money_changed_connect = inventory.connect("currency_changed", self, "_on_money_changed")

func _on_item_added(item: Item, amount: int):
	make_label(str(amount) + 'x '+ item.name)

func _on_money_changed(value):
	make_label("Money: " + str(value))  

func make_label(text):
	var label = Label.new()
	var timer = Timer.new()
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = 3
	label.add_child(timer)
	label.add_font_override('font', font)
	label.text = text
	add_child(label)
	timer.connect("timeout", self, "_vanish_item_text", [label])

func _vanish_item_text(label: Label):
	remove_child(label)
