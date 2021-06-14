extends HBoxContainer


const RECT_SIZE_MAX_x = 1920.0


onready var children = get_children()



func _on_VBoxContainer_resized():
	if children:
		var new_size = rect_size.x / RECT_SIZE_MAX_x
		new_size = lerp(12, 48, new_size)
		
		for child in children:
			child.get("custom_fonts/font").size = new_size
