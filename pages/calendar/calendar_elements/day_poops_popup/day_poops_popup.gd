class_name DayPoopsPopup
extends ScrollContainer


const months := {
	1: "Janvier",
	2: "Février",
	3: "Mars",
	4: "Avril",
	5: "Mai",
	6: "Juin",
	7: "Juillet",
	8: "Août",
	9: "Septembre",
	10: "Octobre",
	11: "Novembre",
	12: "Décembre",
}


@export var poops_data: Array[Dictionary]
@export var day_poop: PackedScene
@export var date: Dictionary

@onready var day_month_label: Label = %DayMonthLabel
@onready var poops_container: VBoxContainer = %PoopsContainer
@onready var bottom_poop: BottomPoop = %BottomPoop

var poops_number: int


func _ready() -> void:
	day_month_label.text = "%s %s" % [date.day, months[date.month]]
	
	_update()


@warning_ignore("unused_parameter")
func _update() -> void:
	for child in poops_container.get_children():
		child.queue_free()
	
	poops_number = poops_data.size()
	
	for poop_data in poops_data:
		var new_day_poop: DayPoop = day_poop.instantiate()
		
		new_day_poop.poop_data = poop_data
		poops_container.add_child(new_day_poop)
	
	bottom_poop.date = date
	


func _on_close_pressed() -> void:
	queue_free()
