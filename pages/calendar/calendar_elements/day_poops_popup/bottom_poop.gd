class_name BottomPoop
extends MarginContainer


@onready var new_poop_button: Button = %NewPoopButton
@export var add_poop_popup: PackedScene

var date := {
	"day": 1,
	"month": 1,
	"year": 2025,
}


func _on_new_poop_button_pressed() -> void:
	var new_add_poop_popup: AddPoopPopup = add_poop_popup.instantiate()
	
	add_child(new_add_poop_popup)
	
	var month_index: int = date.month - 1
	new_add_poop_popup.month_button.select(month_index)
	new_add_poop_popup.add_poop_button.month = date.month
	
	var day_index: int = date.day - 1
	new_add_poop_popup.day_button.select(day_index)
	new_add_poop_popup.add_poop_button.day = date.day
