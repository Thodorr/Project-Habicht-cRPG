extends Node

var skill_data

func _ready():
	var skilldata_file = File.new()
	skilldata_file.open("res://Data/SkillTable - Tabellenblatt1.json", File.READ)
	var skilldata_json = JSON.parse(skilldata_file.get_as_text())
	skilldata_file.close()
	skill_data = skilldata_json.result
