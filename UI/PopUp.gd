extends ColorRect

onready var screen_width = ProjectSettings.get_setting("display/window/size/width")
onready var screen_height = ProjectSettings.get_setting("display/window/size/height")

onready var inventory = preload("res://Inventory.tres")

var curr_item = null

func _ready():
	rect_position.x = screen_width / 2 - rect_size.x / 2
	rect_position.y = screen_height / 2 - rect_size.y / 2
	
	inventory.connect("open_popup", self, "set_popup")

func set_text(text):
	$RichTextLabel.text = text

func set_buttons(accept_text: String, decline_text: String):
	if accept_text == "":
		$AcceptButton.visible = false
		$DeclineButton.rect_position.x = rect_size.x / 2 - $DeclineButton.rect_size.x
	if decline_text == "":
		$DeclineButton.visible = false
		$AcceptButton.rect_position.x = rect_size.x / 2 - $AcceptButton.rect_size.x
	
	$AcceptButton.text = accept_text
	$DeclineButton.text = decline_text

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
