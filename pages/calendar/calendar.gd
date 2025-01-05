extends Control


@export var year_font_color: Color = Color("606060")
@export var separator_color: Color = Color("292929")
@export var cell_colors: Dictionary = {true: Color(0.11, 0.11, 0.11), false: Color(0.09, 0.09, 0.09)}
@export var cell_font_colors : Dictionary = {true: Color.WHITE, false: Color(0.204, 0.204, 0.204)}
@export var month_calendar: PackedScene
@export var calendar_year: PackedScene
@export var calendar_container: VBoxContainer


func _ready() -> void:
	_populate_calendar(2025)


func _populate_calendar(year: int) -> void:
	_depopulate_calendar(year)
	
	var new_year : CalendarYear = calendar_year.instantiate()
	new_year.year = year
	new_year.year_font_color = year_font_color
	new_year.separator_color = separator_color
	calendar_container.add_child(new_year)
	
	for i in range(12):
		var new_month : MonthCalendar = month_calendar.instantiate() 
		new_month.year = year
		new_month.month = i + 1
		new_month.cell_colors = cell_colors
		new_month.cell_font_colors = cell_font_colors
		calendar_container.add_child(new_month)


func _depopulate_calendar(year: int) -> void:
	var calendar_container_childs : = calendar_container.get_children()
	for child in calendar_container_childs:
		if child is Control and "year" in child:
			@warning_ignore("unsafe_property_access") # The property was checked so it is safe ↓
			if child.year == year:
				child.queue_free()
