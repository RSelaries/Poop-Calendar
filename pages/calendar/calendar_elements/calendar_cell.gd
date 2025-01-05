class_name CalendarCell
extends PanelContainer


@export var color: Color
@export var font_color: Color = Color.WHITE
@export var pooped_color: Color = Color("4c260e")
@export var part_of_month: bool

@export var day_poops_popup: PackedScene


var current_font_size := 51

var date := {
	"day": 1,
	"month": 1,
	"year": 2025,
}

var poops_data : Array[Dictionary] = []

@onready var number_node: Label = %Number

@onready var poops : Array[TextureRect] = [%Poop1, %Poop2, %Poop3, %Poop4, %Poop5Plus]


func _ready() -> void:
	Global.update_cells.connect(_update)
	
	number_node.text = str(date.day)
	self_modulate = color
	number_node["theme_override_colors/font_color"] = font_color
	
	name = "%s_%s_%s" % [date.year, date.month, date.day]
	
	_update()


func _update(year: int = date.year, month: int = date.month, day: int = date.day) -> void:
	if year != date.year or month != date.month or day != date.day:
		return
	
	number_node.text = str(date.day)
	self_modulate = color
	number_node["theme_override_colors/font_color"] = font_color
	
	poops_data = Global.poop_database.select_rows("poops", "year = %s AND month = %s AND day = %s" % [date.year, date.month, date.day], ["*"])
	
	var data_size :int = poops_data.size()
	if data_size > 0 and part_of_month:
		self_modulate = pooped_color
		
		var i := 0
		for poop in poops:
			if i < data_size:
				poops[i].visible = true
			else:
				poops[i].visible = false
			i += 1
	else:
		for poop in poops:
			poop.visible = false
	
	var children := get_children()
	for child in children:
		if child is DayPoopsPopup:
			var _child : DayPoopsPopup = child
			_child.poops_data = poops_data
			_child._update()


func _on_button_pressed() -> void:
	var new_day_poops_popup: DayPoopsPopup = day_poops_popup.instantiate()
	new_day_poops_popup.poops_data = poops_data
	new_day_poops_popup.date = date
	add_child(new_day_poops_popup)
