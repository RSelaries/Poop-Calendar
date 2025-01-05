extends Node


@warning_ignore("unused_signal")
signal update_cells(year: int, month: int, day: int)


var poop_database : SQLite

var os_time: Dictionary = {"hour": 00, "minute": 00}:
	get():
		var time := Time.get_time_dict_from_system()
		os_time = {"hour": time.hour, "minute": time.minute}
		return os_time
var os_date: Dictionary = {"year": 0, "month": 0, "minute": 0,}:
	get():
		var date := Time.get_date_dict_from_system()
		os_date = {"year": date.year, "month": date.month, "day": date.day}
		return os_date


func _ready() -> void:
	_create_poop_database()


func _create_poop_database() -> void:
	create_dir("user://databases/")
	poop_database = SQLite.new()
	poop_database.path = "user://databases/poop_database.db"
	poop_database.open_db()
	
	var poop_table := {
		"id": {"data_type": "INT", "primary_key": true, "not_null": true, "auto_increment": true},
		
		"year": {"data_type": "INT"},
		"month": {"data_type": "INT"},
		"day": {"data_type": "INT"},
		"hour": {"data_type": "INT"},
		"minute": {"data_type": "INT"},
		"note": {"data_type": "INT"},
		
		"location": {"data_type": "TEXT"},
		"texture": {"data_type": "TEXT"},
		"size": {"data_type": "TEXT"},
		"transit": {"data_type": "TEXT"},
		"comment": {"data_type": "TEXT"},
	}
	
	poop_database.create_table("poops", poop_table)


func create_dir(dir: String) -> void:
	if !DirAccess.open("user://%s" % dir):
		DirAccess.open("user://").make_dir(dir)
