extends Control

signal CloseOptionsMenu
signal toggleMusic

func _on_ExitButton_pressed():
	emit_signal("CloseOptionsMenu")


func _on_TextureButton_pressed():
	emit_signal("toggleMusic")
