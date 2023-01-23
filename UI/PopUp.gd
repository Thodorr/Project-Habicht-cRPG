extends ColorRect

onready var screen_width = ProjectSettings.get_setting("display/window/size/width")
onready var screen_height = ProjectSettings.get_setting("display/window/size/height")

onready var inventory = preload("res://Engine/Handler/Inventory.tres")

onready var accept_button = $AcceptButton
onready var decline_button = $DeclineButton

onready var accept_label = $AcceptButton/Label
onready var decline_label = $DeclineButton/Label

var curr_item = null

func _ready():
	rect_position.x = screen_width / 2 - rect_size.x / 2
	rect_position.y = screen_height / 2 - rect_size.y / 2
	
	inventory.connect("open_popup", self, "set_popup")

func set_text(text):
	$RichTextLabel.text = text

func set_buttons(accept_text: String, decline_text: String):
	accept_label.set_text(accept_text)
	decline_label.set_text(decline_text)
	
	accept_button.rect_size.x = accept_label.get_font("PixelFontSmall").get_string_size(accept_label.text).x + 2
	decline_button.rect_size.x = decline_label.get_font("PixelFontSmall").get_string_size(decline_label.text).x + 2
	
	if accept_text == "":
		accept_button.visible = false
		decline_button.rect_position.x = rect_size.x / 2 - decline_button.rect_size.x / 2
	if decline_text == "":
		decline_button.visible = false
		accept_button.rect_position.x = rect_size.x / 2 - accept_button.rect_size.x / 2

#Use this function for setup
func set_popup(item, accept_text = "Accept", decline_text = "Decline"):
	visible = true
	curr_item = item
	set_text(item.text_message)
	set_buttons(accept_text, decline_text)


func _on_AcceptButton_pressed():
	curr_item.text_accepted = true
	inventory.use_item(curr_item)
	visible = false


func _on_DeclineButton_pressed():
	visible = false

