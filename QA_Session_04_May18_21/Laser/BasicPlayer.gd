extends KinematicBody2D


const MAX_SPEED = 800
const ACCELERATION = 100

onready var gun_raycast = $Gun
onready var gun_sprite = $Gun
onready var laser = $Gun/Line2D

var input_vector: Vector2
var velocity: Vector2


func _physics_process(delta):
	movement()
	aim()
	shoot_laser()


func movement():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
	
	move_and_slide(velocity)


func aim():
	var target = get_global_mouse_position()
	gun_raycast.set_cast_to(to_local(target))


func shoot_laser():
#	if Input.is_action_pressed("shoot"):
	if gun_raycast.is_colliding():
		laser.points[-1] = to_local(gun_raycast.get_collision_point())
	else:
		laser.points[-1] = gun_raycast.get_cast_to()
#	else:
#		laser.points[-1] = Vector2.ZERO
