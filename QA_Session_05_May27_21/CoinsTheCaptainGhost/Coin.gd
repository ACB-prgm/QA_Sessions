extends Area2D

const MAX_VEL = 2000
const ACCELERATION = 100

var target
var t := .01
var velocity := Vector2.ZERO


func _ready():
	set_physics_process(false)


func _physics_process(delta):
	t += easeInCirc(t) * delta
	global_position = lerp(global_position, target.global_position, t)
#	var direction = global_position.direction_to(target.global_position)
#
#	velocity += direction * ACCELERATION * delta
#	velocity = velocity.clamped(MAX_VEL)
#	global_position += velocity


func easeInCirc(x:float):
	return sqrt(1 - pow(x - 1, 2))


func _on_Coin_area_entered(_area):
	queue_free()


func _on_DetectionArea2D_body_entered(body):
	target = body
	set_physics_process(true)
