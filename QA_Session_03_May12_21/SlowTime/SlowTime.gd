extends Node


onready var timer := Timer.new()


func _ready():
#	set_process(false)
	add_child(timer)
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.set_one_shot(true)


#func _process(delta):
#	Engine.time_scale = lerp(Engine.time_scale, 1.0, .05)
#	if Engine.time_scale > 0.95:
#		Engine.time_scale = 1.0
#		set_process(false)

func start_slow(duration = 1.0, slow_speed = 0.1):
	timer.wait_time = duration * slow_speed
	timer.start()
	
	Engine.time_scale = slow_speed


func stop_slow():
	Engine.time_scale = 1.0


func _on_timer_timeout():
#	set_process(true)
	stop_slow()

