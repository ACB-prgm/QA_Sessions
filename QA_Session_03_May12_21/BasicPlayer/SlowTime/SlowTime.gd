extends Node


var timer := Timer.new()


func _ready():
	add_child(timer)

func start_slow(duration = 1.0, slowspeed = 0.1):
	timer.wait_time = duration * slowspeed
	timer.start()
	
	Engine.time_scale = slowspeed


func _on_Timer_timeout():
	Engine.time_scale = 1.0
