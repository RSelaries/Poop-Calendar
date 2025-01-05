class_name CalendarYear
extends VBoxContainer


@export var year: int = 2025
@export var year_font_color: Color = Color("606060")
@export var separator_color: Color = Color("292929")

@export var year_label: Label
@export var separator: ColorRect


func _ready() -> void:
	year_label.text = str(year)
	year_label["theme_override_colors/font_color"] = year_font_color
	
	separator.color = separator_color
	
