class_name AddPoopButton
extends Button


var year := 2025
var month := 1
var day := 1

var hour := 00
var minute := 00

var note := 0

var location := ""
var texture := "Normal"
var poop_size := "Moyen"
var transit := "Normal"
var comment := ""


@onready var add_poop_popup : AddPoopPopup = owner


func _on_pressed() -> void:
	_add_poop_data_to_db()
	
	add_poop_popup._closing_transition()
	Global.update_cells.emit(year, month, day)


func _add_poop_data_to_db() -> void:
	var poop_data := {
		"year": year,
		"month": month,
		"day": day,
		"hour": hour,
		"minute": minute,
		"note": note,
		
		"location": location,
		"texture": texture,
		"size": poop_size,
		"transit": transit,
		"comment": comment,
	}
	Global.poop_database.insert_row("poops", poop_data)
