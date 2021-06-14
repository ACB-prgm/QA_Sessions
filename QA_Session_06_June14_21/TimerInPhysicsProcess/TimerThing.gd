extends Node2D



onready var timer = $Timer

var can_shoot = true


func _physics_process(delta):
	if Input.is_action_just_pressed("shoot") and can_shoot:
		timer.start()
		can_shoot = false
		print("shoot")


func _on_Timer_timeout():
	can_shoot = true
	print("timeout")
