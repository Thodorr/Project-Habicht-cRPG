extends Button

var check : Check = null
var labelText = ''

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("button_down", self, "_on_pressed")
	Attributes.connect("dice_rolled", self, "_change_dice_label")
	get_check()
	labelText = text
	append_label(text)
	text = ''

func get_check():
	if "#" in text:
		var checkName = text.get_slice('#', 1)
		check = CheckHandler.get_check_by_name(checkName)
		text = text.replace('#'+checkName+'#', '[' + str(Attributes.Attribute.keys()[check.type]) + ': '+ str(check.difficulty) + ']')

func _on_mouse_entered():
	if "[" in labelText:
		if (check.state <= 0):
			disabled = false
			hint_tooltip = 'Probability: ' + str(Attributes.get_probability(check))+'%'
			hint_tooltip += '\nRequired roll: ' + str(Attributes.get_required_roll(check))
			if check.influences.size() >= 1:
				hint_tooltip += '\nInfluenced Difficulty: ' + str(check.get_influenced_difficulty())
				hint_tooltip += '\n\nInfluences: \n' + stringify_influences()
		else:
			disabled = true
			hint_tooltip = 'You can not repeat this check!'
	else:
		hint_tooltip = ""

func stringify_influences():
	var influence_str = str(check.influences).substr(1, str(check.influences).length()-2)
	influence_str = influence_str.replace(', ', ',\n').replace(':', ': ')
	return influence_str

func _on_pressed():
	if check == null: return
	var checkAnim = get_parent().get_parent().get_parent().get_node('CheckAnim')
	var animPlayer: AnimationPlayer = checkAnim.get_node('AnimationPlayer')
	Dialogic.set_variable('Result', Attributes.do_check2(check))
	var result: String = Dialogic.get_variable('Result')
	if result == 'True':
		animPlayer.play('Clock')
		check.state = 1
	else:
		animPlayer.play('CheckFail')
		check.state = 2

func _change_dice_label(dice):
	var checkAnim = get_parent().get_parent().get_parent().get_node('CheckAnim')
	var dice_label: Label = checkAnim.get_node('TextureRect/Label')
	dice_label.text = str(dice)

func append_label(text):
	var textLabel = $RichTextLabel
	textLabel.fit_content_height = true
	textLabel.rect_position = Vector2(2,5)
	textLabel.append_bbcode(text)

	rect_min_size.y = $RichTextLabel.get_font("PixelFontVerySmall").get_string_size(text).x / 18.5 + 8
	rect_size.y = $RichTextLabel.get_font("PixelFontVerySmall").get_string_size(text).x / 18.5 + 8
	
	var new_size = $RichTextLabel.get_font("PixelFontVerySmall").get_string_size(text).x / 1.8 + 10
	if new_size > $RichTextLabel.rect_size.x:
		new_size = $RichTextLabel.rect_size.x
	
	rect_min_size.x = new_size + 3
	rect_size.x = new_size + 3

func _process(delta):
	if (rect_position.x != 0): rect_position.x = 0
	
	if Input.is_action_pressed(get_meta('input_next')):
		if has_focus():
			emit_signal("button_down")
	if Input.is_action_just_released(get_meta('input_next')):
		if has_focus():
			emit_signal("button_up")
			emit_signal("pressed")
