extends KinematicBody2D


const BLK = Color(.4, 0, 0, 1)
const BLU = Color(0, 1, 1, 1)
const PRPL = Color(1, 0, 1, 1)
const YLW = Color(1, 1, 0, 1)
const MAX_VEL = 1000
const ACCELERATION = 100

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var dead = false
var score = 50
var health = 3
var isGrounded = true

onready var tween = $Tween


func _ready():
	Globals.player = self
	randomize()
	pick_random_color()


func _physics_process(_delta):
	movement()


func movement():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	look_at(input_vector + global_position)
	if rotation > PI/2 or rotation < -PI/2:
		$Sprite.flip_v = true
	else:
		$Sprite.flip_v = false
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_VEL)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
	
	move_and_slide(velocity)


func _on_Area2D_body_entered(body):
	if body.modulate == self.modulate:
		score += 1
		print(score)
	else:
		hit()

func hit():
	tween.interpolate_property(self, "modulate:a", 0, 1,
	.4, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()
	
	health -= 1
	if health <= 0:
		die()



func die():
	if !dead:
		dead = true
		queue_free()




func _on_Timer_timeout():
	pick_random_color()


func pick_random_color():
	var flip = rand_range(0, 16)
	
	if flip < 4.0:
		modulate = BLK
	elif flip > 12.0:
		modulate =  BLU
	elif flip > 8.0 and flip < 12.0:
		modulate = PRPL
	else:
		modulate = YLW
