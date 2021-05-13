extends RayCast2D


const SPEED = 5000

onready var detectionRayCast = $DetectionRayCast2D

var dead = false
var slowing = false


func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(rotation).normalized() * SPEED * delta
	
	if detectionRayCast.is_colliding():
		SlowTime.start_slow(5.0)
	
	if is_colliding():
		SlowTime.stop_slow()
		die()


func _on_VisibilityNotifier2D_screen_exited():
	die()


func die():
	if !dead:
		dead = true
		queue_free()
