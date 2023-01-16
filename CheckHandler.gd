extends Node

var checks = []

func _ready():
	var dir = Directory.new()
	if dir.open("res://Units/Checks/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				checks.append(load("res://Units/Checks/"+ file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func get_check(check):
	get_check_by_name(check.name)

func get_check_by_name(check_name):
	for target_check in checks:
		if target_check is Check:
			if target_check.name == check_name:
				return target_check
