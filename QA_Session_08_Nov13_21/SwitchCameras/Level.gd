extends Node2D


var cameras = []

onready var main_cam = $Camera2D
onready var player_cam = $Player/Camera2D2


func _input(event):
	if event.is_action_pressed("ui_accept"):
		if main_cam.current:
			player_cam.current = true
			main_cam.current = false
		else:
			player_cam.current = false
			main_cam.current = true
		prints(main_cam.current, player_cam.current)
