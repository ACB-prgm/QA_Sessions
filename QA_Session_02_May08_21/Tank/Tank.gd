extends KinematicBody2D


const MAX_SPEED = 1000
const ACCELERATION = 100

onready var gun = $Gun
onready var body = $Sprite
onready var animPlayer = $AnimationPlayer
onready var anims = ["hit", "shoot"]

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO


func _ready():
	print(anims)
	randomize()


func _physics_process(delta):
	movement()
	aiming()


func movement():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
	
	rotation = input_vector.angle()
	move_and_slide(velocity)


func aiming():
	gun.look_at(get_global_mouse_position())


func _on_Timer_timeout():
	anims.shuffle()
	animPlayer.play(anims[0])
