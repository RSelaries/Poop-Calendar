class_name MonthCalendar
extends MarginContainer


const month_nbr_of_days = {
	1: 31,
	2: 28,
	3: 31,
	4: 30,
	5: 31,
	6: 30,
	7: 31,
	8: 31,
	9: 30,
	10: 31,
	11: 30,
	12: 31,
}
const aspect_ratios = {
	35: 1.4,
	42: 1.16666666666,
}

@export var year: int = 2025:
	set(value):
		year = value
		if ready_has_run:
			generate_calendar_month()
@export_range(1, 12) var month: int = 1:
	set(value):
		month = value
		if ready_has_run:
			generate_calendar_month()
## Color true is for active cell, false is for inactive ones
@export var cell_colors : Dictionary = {true: Color(0.11, 0.11, 0.11), false: Color(0.09, 0.09, 0.09)}
@export var cell_font_colors : Dictionary = {true: Color.WHITE, false: Color(0.204, 0.204, 0.204)}
@export var calendar_cell : PackedScene
@export var calendar_cell_container: GridContainer
@export var month_label: Label

var _cell_numbers: Array[int] = []
var _cell_part_of_month: Array[bool] = []
var cells : Array[CalendarCell] = []

var ready_has_run: bool = false


func _ready() -> void:
	name = "%s_%s" % [year, month]
	
	generate_calendar_month()
	ready_has_run = true


func generate_calendar_month() -> void:
	_generate_cell_numbers()
	
	# Deletes every childs if there are any, to reset the calendar
	if calendar_cell_container:
		if calendar_cell_container.get_child_count() != 0:
			for child in calendar_cell_container.get_children():
				child.queue_free()
	else:
		push_warning("Erreur : pas de node CalendarCellContainer trouvé")
	
	# Add the cells
	var i: int = 0
	for cell in _cell_numbers:
		if calendar_cell:
			var new_cell : CalendarCell = calendar_cell.instantiate()
			new_cell.date = {"day": cell, "month": month, "year": year}
			new_cell.part_of_month = _cell_part_of_month[i]
			new_cell.color = cell_colors[_cell_part_of_month[i]]
			new_cell.font_color = cell_font_colors[_cell_part_of_month[i]]
			calendar_cell_container.add_child(new_cell)
			i += 1
		else:
			push_warning("Erreur : pas de node CalendarCell trouvé")
	
	var month_name: String
	match month:
		1: month_name = "Janvier"
		2: month_name = "Février"
		3: month_name = "Mars"
		4: month_name = "Avril"
		5: month_name = "Mai"
		6: month_name = "Juin"
		7: month_name = "Juillet"
		8: month_name = "Août"
		9: month_name = "Septembre"
		10: month_name = "Octobre"
		11: month_name = "Novembre"
		12: month_name = "Décembre"
	if month_label:
		month_label.text = month_name
	else:
		push_warning("Erreur : pas de node MonthLabel trouvé")


func _generate_cell_numbers() -> void:
	_cell_numbers.clear()
	_cell_part_of_month.clear()
	
	var nbr_of_days: int = month_nbr_of_days[month]
	var prvs_month_nbr_days: int = month_nbr_of_days[month - 1 if month > 1 else 12]
	var offset : int
	
	var first_number: int
	var first_day: int = get_day_of_week(year, month, 1)
	if first_day == 1: # Si le premier jour du mois est un Lundi, la première case sera le 1
		first_number = 1
	else:
		if first_day == 0: # For Sundays, wich should be 7 and not 0 with this script
			first_day = 7
		offset = first_day - 2 # De combien on doit décaler le premier chiffre
		offset = clamp(offset, 0, 7)
		
		first_number = prvs_month_nbr_days - offset
	
	var number_of_cells := closest_higher_multiple(nbr_of_days + offset + 1, 7)
	
	var y := 1
	for i in range(number_of_cells):
		if first_number != 1 and first_number + i <= prvs_month_nbr_days:
			_cell_numbers.append(first_number + i)
			_cell_part_of_month.append(false)
		else:
			if y <= nbr_of_days:
				_cell_numbers.append(y)
				_cell_part_of_month.append(true)
			else:
				_cell_numbers.append(y - nbr_of_days)
				_cell_part_of_month.append(false)
			y += 1


## Fonction pour obtenir le jour de la semaine
## Renvoie 0 pour Dimanche, 1 pour Lundi, ..., 6 pour Samedi
func get_day_of_week(yr: int, mnth: int, dy: int) -> int:
	if mnth < 3:
		mnth += 12
		yr -= 1
	var K := yr % 100
	@warning_ignore("integer_division")
	var J := yr / 100
	@warning_ignore("integer_division")
	var h := (dy + int((13 * (mnth + 1)) / 5) + K + int(K / 4) + int(J / 4) - 2 * J) % 7
	var day_of_week := (h + 6) % 7  # Ajustement pour que 0 soit Dimanche
	
	return day_of_week


func closest_higher_multiple(value: int, multiple_of: int) -> int:
	@warning_ignore("integer_division")
	return ((value + (multiple_of - 1)) / multiple_of) * multiple_of
