extends Button



func _on_MoveTOArea_pressed():
	Globals.player.move_to(rect_position)
