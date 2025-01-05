class_name EditPoopPopup
extends Control


const months = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]
const month_days_count = {
	1 : 31,
	2 : 28,
	3 : 31,
	4 : 30,
	5 : 31,
	6 : 30,
	7 : 31,
	8 : 31,
	9 : 30,
	10 : 31,
	11 : 30,
	12 : 31,
}


@export var add_poop_page : PanelContainer

## =========== BUTTONS ===============
@export_group("Buttons")
@export var close_button : TextureButton
@export var day_button : OptionButton
@export var month_button : OptionButton
@export var year_button : OptionButton
@export var hour_button : OptionButton
@export var minute_button : OptionButton
@export var location_line_edit : LineEdit
@export var texture_button : OptionButton
@export var size_button : OptionButton
@export var transit_button : OptionButton
@export var comment_button : TextEdit

@export var edit_poop_button : EditPoopButton

@export var stars_button : Array[Button]
@export var stars_texture : Array[TextureRect]
## =====================================

## =========== TEXTURES ===============
@export_group("Textures")
@export var full_star_texture : Texture2D
@export var empty_star_texture : Texture2D
## =====================================


var note := 0:
	set(value):
		note = value
		if ready_has_run:
			_init_star_textures()
			poop_data.note = value

var ready_has_run := false

var poop_data: Dictionary


@onready var original_poop_data: Dictionary = poop_data.duplicate()

@onready var close_button_texture : GradientTexture1D = close_button.texture_normal
@onready var close_button_gradient : Gradient = close_button_texture.gradient
@onready var close_button_color : Color = close_button_texture.gradient.colors[0]


func _ready() -> void:
	edit_poop_button.original_poop_data = poop_data
	
	_opening_transition()
	
	_init_day_number_button()
	_init_star_textures()
	_init_year_button()
	_init_hour_button()
	_init_minute_button()
	
	_set_data_as_poop_data()
	
	ready_has_run = true

func _opening_transition() -> void:
	var tween : Tween = create_tween()
	
	# Opacity transition
	close_button_color = Color(0, 0, 0, 0)
	tween.tween_property(close_button_gradient, "colors", PackedColorArray([Color(0, 0, 0, 0.5)]), 0.1)
	
	# Slide up transition
	var _add_poop_page_final_position : Vector2 = add_poop_page.position
	add_poop_page.position.y = get_window().size.y
	tween.tween_property(add_poop_page, "position", _add_poop_page_final_position, 0.2)

func _closing_transition() -> void:
	var tween : Tween = create_tween()
	
	# Opacity transition
	tween.tween_property(close_button_gradient, "colors", PackedColorArray([Color(0, 0, 0, 0)]), 0.02)
	
	# Slide up transition
	tween.tween_property(add_poop_page, "position", Vector2(add_poop_page.position.x, get_window().size.y), 0.05)
	
	var timer := Timer.new()
	timer.wait_time = 0.05
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", queue_free)

## ===== Initialize Buttons Values =====
func _init_day_number_button() -> void:
	day_button.clear()
	var nbr_of_days: int = month_days_count[poop_data.month]
	
	for i in nbr_of_days as int:
		day_button.add_item("%02d" % (i + 1), (i + 1) )

func _init_year_button() -> void:
	year_button.clear()
	const year_start = 2025
	for i in range(3):
		year_button.add_item(str(year_start + i), year_start + i)

func _init_star_textures() -> void:
	var index := 0
	for star_texture in stars_texture:
		if index < poop_data.note:
			star_texture.texture = full_star_texture
		else:
			star_texture.texture = empty_star_texture
		index += 1

func _init_hour_button() -> void:
	hour_button.clear()
	for i in range(24):
		hour_button.add_item("%02d" % i)

func _init_minute_button() -> void:
	minute_button.clear()
	for i in range(60):
		minute_button.add_item("%02d" % i)
## =====================================


## ===== Button Functions ==============
func _on_close_button_pressed() -> void:
	_closing_transition()


# ===== Date ==============
func _on_day_name_button_item_selected(index: int) -> void:
	poop_data.day = int(day_button.get_item_text(index))

func _on_month_name_button_item_selected(index: int) -> void:
	var currently_selected_day := day_button.selected + 1
	
	poop_data.month = months[index]
	_init_day_number_button()
	
	if currently_selected_day > month_days_count[poop_data.month]:
		var last_day : int = month_days_count[poop_data.month] - 1
		day_button.select(last_day)
	else:
		day_button.select(currently_selected_day - 1)

func _on_year_name_button_item_selected(index: int) -> void:
	poop_data.year = int(year_button.get_item_text(index))
# ========================


# ===== Hour ==============
func _on_hour_button_item_selected(index: int) -> void:
	poop_data.hour = int(hour_button.get_item_text(index))

func _on_minute_button_item_selected(index: int) -> void:
	poop_data.minute = int(minute_button.get_item_text(index))
# ========================


func _on_location_line_edit_text_changed(new_text: String) -> void:
	poop_data.location = new_text


# ===== Texture, Size, Transit ====
func _on_texture_button_item_selected(index: int) -> void:
	poop_data.texture = str(texture_button.get_item_text(index))

func _on_transit_button_item_selected(index: int) -> void:
	poop_data.transit = str(transit_button.get_item_text(index))

func _on_size_button_item_focused(index: int) -> void:
	poop_data.poop_size = str(size_button.get_item_text(index))
# =================================


# ======= Stars ==========
func _on_star_1_button_pressed() -> void:
	note = 1

func _on_star_2_button_pressed() -> void:
	note = 2

func _on_star_3_button_pressed() -> void:
	note = 3

func _on_star_4_button_pressed() -> void:
	note = 4

func _on_star_5_button_pressed() -> void:
	note = 5

func _on_comment_text_edit_text_changed() -> void:
	poop_data.comment = str(comment_button.text)
# ========================
## =====================================


func _set_data_as_poop_data() -> void:
	_init_star_textures()
	
	var day_nbr: int = poop_data.day
	day_button.select(day_nbr - 1)
	
	var month_nbr: int = poop_data.month
	month_button.select(month_nbr - 1)
	
	var year_nbr: int = poop_data.year
	year_button.select(year_button.get_item_index(year_nbr))
	
	var hour_nbr: int = poop_data.hour
	hour_button.select(hour_nbr)
	
	var minute_nbr: int = poop_data.minute
	minute_button.select(minute_nbr)
	
	var texture_string: String = poop_data.texture
	texture_button.text = texture_string
	
	var transit_string: String = poop_data.transit
	transit_button.text = transit_string
	
	var size_string: String = poop_data.size
	size_button.text = size_string
	
	var location_string: String = poop_data.location
	location_line_edit.text = location_string
	
	var comment_string: String = poop_data.comment
	comment_button.text = comment_string


func _on_delete_poop_button_pressed() -> void:
	Global.poop_database.delete_rows("poops", "id = %s" % original_poop_data.id)
	Global.update_cells.emit(original_poop_data.year, original_poop_data.month, original_poop_data.day)
