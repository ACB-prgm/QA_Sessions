extends KinematicBody2D


const MAX_SPEED = 1000
const ACCELERATION = 100

onready var gun = $GunSprite
onready var barrelPos = $GunSprite/BarrelPosition2D

var bullet_TSCN = preload("res://QA_Sessions/QA_Session_03_May12_21/BasicPlayer/PlayerBullet.tscn")
var input_vector: Vector2
var velocity: Vector2
var is_jumping = false
var fall_velocity := Vector2.ZERO
var ground: Vector2
const fall_max = 21.0
var fall_amount := 0


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
	
	jump()
# warning-ignore:return_value_discarded
	move_and_slide(velocity + fall_velocity)


func jump():
	
	if is_jumping:
		fall_velocity.y += 100
		$Ground.global_position = ground
		fall_amount -= 1
		
		if fall_amount <= 0:
			fall_amount = 0
			is_jumping = false
			fall_velocity = Vector2.ZERO
		
		$Sprite.scale = lerp(Vector2(2,2), Vector2(3,3), fall_amount/fall_max)
	
	if Input.is_action_just_pressed("shoot") and !is_jumping:
		ground = $Ground.global_position
		fall_amount += fall_max
		is_jumping = true
		velocity += Vector2(0, -2000)



func aim():
	gun.look_at(get_global_mouse_position())


func shoot():
	if Input.is_action_just_pressed("shoot"):
		var bullet_ins = bullet_TSCN.instance()
		bullet_ins.global_position = barrelPos.global_position
		bullet_ins.rotation = gun.rotation
		get_parent().call_deferred("add_child", bullet_ins)
