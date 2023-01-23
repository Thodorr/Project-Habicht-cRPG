extends HBoxContainer

onready var effectUI = preload("res://UI/Effect.tscn")

func _ready():
	var _effects_changed_connect = Attributes.connect("effectAdded", self, "_on_effects_changed")

func _on_effects_changed(effects):
	var effect = effects[0]
	var effectUiInstance = effectUI.instance()
	effectUiInstance.texture = effect.texture
	effectUiInstance.get_child(0).text = str(effect.effect_duration)
	add_child(effectUiInstance)
	effectUiInstance.get_child(1).connect("timeout", self, "_on_timeout", [effectUiInstance])
	effectUiInstance.get_child(1).start(effect.effect_duration)

func _process(_frame):
	for effectUi in get_children():
		var timer = effectUi.get_child(1)
		var label = effectUi.get_child(0)
		
		label.text = str(round(timer.get_time_left()))
		
func _on_timeout(effect):
	remove_child(effect)
