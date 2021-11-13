extends KinematicBody2D


const MAX_SPEED = 1000
const ACCELERATION = 100

onready var gun = $GunSprite
onready var barrelPos = $GunSprite/BarrelPosition2D

var bullet_TSCN = preload("res://QA_Sessions/QA_Session_03_May12_21/BasicPlayer/PlayerBullet.tscn")
var input_vector: Vector2
var velocity: Vector2

signal is_player(player)


func _ready():
	emit_signal("is_player", self)


func _physics_process(_delta):
	movement()
	aim()
	shoot()


func movement():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
	
# warning-ignore:return_value_discarded
	move_and_slide(velocity)


func aim():
	gun.look_at(get_global_mouse_position())


func shoot():
	if Input.is_action_just_pressed("shoot"):
		var bullet_ins = bullet_TSCN.instance()
		bullet_ins.global_position = barrelPos.global_position
		bullet_ins.rotation = gun.rotation
		get_parent().call_deferred("add_child", bullet_ins)
