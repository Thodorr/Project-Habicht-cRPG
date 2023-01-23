extends RichTextLabel


func _ready():
	var _attributes_changed_signal = Attributes.connect("attributes_changed", self, "_on_attributes_changed")
	text = str(Attributes.attributes)

func _on_attributes_changed():
	text = str(Attributes.attributes)
