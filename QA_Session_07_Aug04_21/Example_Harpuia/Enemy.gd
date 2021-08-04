extends KinematicBody2D


const MAX_VEL = 800
const ACCELERATION = 100

const BLK = Color(.4, 0, 0, 1)
const BLU = Color(0, 1, 1, 1)
const PRPL = Color(1, 0, 1, 1)
const YLW = Color(1, 1, 0, 1)


var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var dead = false

signal enemy_died


func _ready():
	randomize()
	
	var flip = rand_range(0, 16)
	
	if flip < 4.0:
		modulate = BLK
	elif flip > 12.0:
		modulate =  BLU
	elif flip > 8.0 and flip < 12.0:
		modulate = PRPL
	else:
		modulate = YLW


func _physics_process(_delta):
	movement()


func movement():
	if Globals.player:
		input_vector = global_position.direction_to(Globals.player.global_position)
	else:
		input_vector = Vector2.ZERO
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_VEL)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)

	move_and_slide(velocity)


func _on_Area2D_body_entered(body):
	if body.collision_layer != 2:
		if body.modulate == self.modulate:
			die()
		else:
			velocity = Vector2.ZERO


func die():
	if !dead:
		dead = true
		emit_signal("enemy_died")
		queue_free()
