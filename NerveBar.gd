extends TextureProgress

func _ready():
	var _stress_changed_connect = Attributes.connect("stressChanged", self, "_on_stress_changed")
	_on_stress_changed()

func _on_stress_changed(_value = 0):
	print("Nerve_damage", Attributes.nerve_damage)
	max_value = Attributes.nerve
	value = Attributes.nerve
	$NerveBar.max_value = Attributes.nerve
	$NerveBar.value = Attributes.nerve - Attributes.nerve_damage
