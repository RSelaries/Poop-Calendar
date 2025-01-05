class_name DayPoop
extends VBoxContainer


@export var poop_data: Dictionary
@export var edit_poop_popup: PackedScene

@export var full_star_texture: Texture2D
@export var empty_star_texture: Texture2D

@onready var hour_label: Label = %HourLabel
@onready var location_label: Label = %LocationLabel
@onready var edit_button: Button = %EditButton
@onready var star_1_texture: TextureRect = %Star1Texture
@onready var star_2_texture: TextureRect = %Star2Texture
@onready var star_3_texture: TextureRect = %Star3Texture
@onready var star_4_texture: TextureRect = %Star4Texture
@onready var star_5_texture: TextureRect = %Star5Texture
@onready var comment_label: Label = %CommentLabel
@onready var size_label: Label = %SizeLabel
@onready var texture_label: Label = %TextureLabel
@onready var transit_label: Label = %TransitLabel

@onready var stars : Array[TextureRect] = [star_1_texture, star_2_texture, star_3_texture, star_4_texture, star_5_texture]


func _ready() -> void:
	_update()


func _update() -> void:
	name = "%s_%s" % [poop_data.hour, poop_data.minute]
	hour_label.text = "%02d : %02d" % [poop_data.hour, poop_data.minute]
	
	location_label.text = poop_data.location
	
	var i := 0
	for star in stars:
		if i < poop_data.note:
			star.texture = full_star_texture
		else:
			star.texture = empty_star_texture
		i += 1
	
	size_label.text = poop_data.size
	transit_label.text = poop_data.transit
	texture_label.text = poop_data.texture
	
	comment_label.text = poop_data.comment


func _on_edit_button_pressed() -> void:
	var new_edit_poop_popup: EditPoopPopup = edit_poop_popup.instantiate()
	new_edit_poop_popup.poop_data = poop_data
	
	add_child(new_edit_poop_popup)
