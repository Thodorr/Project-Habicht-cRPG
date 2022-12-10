extends CollisionShape2D

func _on_change(area: Area2D):
	if area.is_in_group("Player"):
		get_tree().change_scene("res://Level/level_1/level_1_entrance.tscn")
	
