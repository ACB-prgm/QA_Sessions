extends StaticBody2D


onready var underline_material = $Sprite.get_material()



func underline():
	underline_material.set("shader_param/flash_amount", 1.0)


func stop_underline():
	underline_material.set("shader_param/flash_amount", 0.0)
