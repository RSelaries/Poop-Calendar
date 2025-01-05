class_name EditPoopButton
extends Button


@export var poop_data: Dictionary
@export var original_poop_data: Dictionary

@onready var add_poop_popup : EditPoopPopup = owner


func _ready() -> void:
	poop_data = add_poop_popup.poop_data


func _on_pressed() -> void:
	print("")
	print(original_poop_data)
	print("Was updated to : ")
	print(poop_data)
	
	Global.poop_database.update_rows("poops", "id = %s" % poop_data.id, poop_data)
	
	Global.update_cells.emit(poop_data.year, poop_data.month, poop_data.day)
	
	queue_free()
