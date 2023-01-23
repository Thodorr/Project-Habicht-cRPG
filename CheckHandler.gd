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

func save():
	var save_dict = {
		"filename" : "checks",
	}
	for check in checks:
		if check != null:
			var array = [check.type, check.difficulty, check.influences, check.repeatable, check.state]
			var check_dict = {
				check.name : array
			}
			save_dict.merge(check_dict, false)
	return save_dict

func loadChecks(node_data):
	var loadedChecks = []
	for checkname in node_data.keys():
		if checkname == "filename":
			continue
		var check = load("res://Units/Checks/" + checkname + ".tres")
		var checkarray = node_data[checkname]
		check.type = int(checkarray[0])
		check.difficulty = int(checkarray[1])
		check.repeatable = checkarray[3]
		check.state = checkarray[4]
		check.influences = checkarray[2]
		loadedChecks.append(check)
	checks = loadedChecks
