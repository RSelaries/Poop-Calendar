extends PanelContainer


@export var page_handler: PageHandler
@export var add_poop_popup: PackedScene
@export var current_page: String = "Calendar"


func _on_calendar_button_pressed() -> void:
	page_handler.change_page("Calendar")


func _on_graphs_button_pressed() -> void:
	page_handler.change_page("Graphs")


func _on_contacts_button_pressed() -> void:
	page_handler.change_page("Contacts")


func _on_add_entry_button_pressed() -> void:
	var poop_popup : Control = add_poop_popup.instantiate()
	
	poop_popup.top_level = true
	add_child(poop_popup)
