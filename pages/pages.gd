class_name PageHandler
extends Control


## Change from current page to [param page_name]. [br]
## Pages include : Calendar, Graphs, Contacts
func change_page(page_name: String) -> void:
	var pages := get_children()
	
	for page in pages:
		if page is CanvasItem:
			var _page := page as CanvasItem
			if _page.name == page_name:
				_page.visible = true
			else:
				_page.visible = false
