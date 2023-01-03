extends Button

var check : Check = null
var labelText = ''

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	get_check()
	labelText = text
	append_label(text)
	text = ''

func get_check():
	if "#" in text:
		var checkName = text.get_slice('#', 1)
		check = load("res://Units/Checks/" + checkName + ".tres")
		text = text.replace('#'+checkName+'#', '[' + str(Attributes.Attribute.keys()[check.type]) + ': '+ str(check.difficulty) + ']')

func _on_mouse_entered():
	if "[" in labelText:
		print("found")
		hint_tooltip = str(Attributes.get_probability(check))+'%'
	else:
		print("noztfound")
		hint_tooltip = ""

func append_label(text):
	var textLabel = $RichTextLabel
	textLabel.fit_content_height = true
	textLabel.rect_position = Vector2(2,5)
	textLabel.append_bbcode(text)

	rect_min_size.y = $RichTextLabel.get_font("PixelFontVerySmall").get_string_size(text).x / 20 + 8
	rect_size.y = $RichTextLabel.get_font("PixelFontVerySmall").get_string_size(text).x / 20 + 8
	
	var new_size = $RichTextLabel.get_font("PixelFontVerySmall").get_string_size(text).x /3 + 10
	if new_size > $RichTextLabel.rect_size.x:
		new_size = $RichTextLabel.rect_size.x
	
	rect_min_size.x = new_size
	rect_size.x = new_size

func _process(delta):
	if (rect_position.x != 0): rect_position.x = 0
	
	if Input.is_action_pressed(get_meta('input_next')):
		if has_focus():
			emit_signal("button_down")
	if Input.is_action_just_released(get_meta('input_next')):
		if has_focus():
			emit_signal("button_up")
			emit_signal("pressed")
