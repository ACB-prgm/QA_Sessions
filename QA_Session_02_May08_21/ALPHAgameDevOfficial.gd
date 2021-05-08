extends Sprite


const STEP = 128

onready var raycast = $RayCast2D
onready var tween = $Tween
onready var movementTimer = $MovementTimer
onready var target = get_parent().get_node("Chest")

var collided = 0
var input_vector = Vector2.ZERO
var movement_options = [
	Vector2.ZERO,
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.UP,
	Vector2.DOWN
]


func _ready():
	randomize()


func _on_MovementTimer_timeout():
	pick_input_vector()
	
	raycast.rotation = input_vector.angle()
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		collided += 1
		_on_MovementTimer_timeout()
	else:
		collided = 0
		tween.interpolate_property(self, "global_position", 
		global_position, global_position + STEP*input_vector, 
		movementTimer.wait_time, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		
		movementTimer.start()


func pick_input_vector():
	if !target:
		movement_options.shuffle()
		input_vector = movement_options[0]
	else:
		var dir = global_position.direction_to(target.global_position)
		if collided == 0:
			if abs(dir.x) > abs(dir.y):
				input_vector = Vector2(dir.x, 0).normalized()
			else:
				input_vector = Vector2(0, dir.y).normalized()
		elif collided == 1:
			if abs(dir.x) > abs(dir.y):
				input_vector = Vector2(0, dir.y).normalized()
			else:
				input_vector = Vector2(dir.x, 0).normalized()
		else:
			var flip = 1
			if rand_range(0,5) > 2.5:
				flip = -1
			input_vector = input_vector.rotated(PI/2.0 * flip)
