tool
extends Node2D
class_name DebugShape2D

var drawing_rect: = Rect2(Vector2.ZERO, Vector2.ONE) setget set_drawing_rect

#func _ready():
#	if Engine.editor_hint: return
#

func _draw():
	if not Engine.editor_hint and not get_tree().debug_collisions_hint:
		return
	var draw_color: Color = ProjectSettings.get("debug/shapes/collision/shape_color")
	draw_rect(drawing_rect, draw_color)

func _get_property_list():
	return [
		{
			name = "DebugShape2D",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			name = "drawing_rect",
			type = TYPE_RECT2,
			usage = PROPERTY_USAGE_DEFAULT
		}
	]

func _set(property: String, value):
	match property:
		"draw_rect":
			drawing_rect = value

func _get(property: String):
	match property:
		"draw_rect":
			return drawing_rect

func set_drawing_rect(value):
	drawing_rect = value
	update()
