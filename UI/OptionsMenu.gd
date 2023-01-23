extends Control

signal CloseOptionsMenu

func _on_ExitButton_pressed():
	emit_signal("CloseOptionsMenu")
