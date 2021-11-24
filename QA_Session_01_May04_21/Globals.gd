tool
extends Node

#**************************************************************
# YOU NEED TO MAKE THIS A GLOBAL SCRIPT OTHERWISE IT WILL NOT WORK!
# GO TO PROJECT > PROJECT SETTINGS > AUTOLOAD > CLICK THE LIL FILE ICON
# THEN SELECT THIS SCRIPT AND CLICK ADD

var mouse_pos: Vector2

signal global_player_set

var player = null setget set_global_player

func _print(arg):
	print(arg)

func set_global_player(new_player):
	player = new_player
	emit_signal("global_player_set")
