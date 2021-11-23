tool
extends Enemy

export(float, 0.1, 1000, 0.1) var detection_radius : float setget set_detection_radius

onready var timer : Timer = $Timer
onready var tween : Tween = $Tween
var blackboard

var _distance_met := 0.0
var _state := 0

func _ready() -> void:
	if Engine.editor_hint:
		set_process(false)
		set_physics_process(false)
		return
	
	$Blackboard.queue_free()
	
	set_meta('initial_position', global_position)
	
#	yield(get_tree().create_timer(1), 'timeout')
#	_state = 1
#	direction.x = -1
	
#	blackboard = $Blackboard
#	blackboard.set_data('detection_size', detection_radius)
#	blackboard.set_data('player', Game.get_player())
#	blackboard.set_data('initial_position', global_position)
#	blackboard.set_data('charge_speed', 200)

func _draw() -> void:
	var draw_color : Color = ProjectSettings.get_setting('debug/shapes/collision/shape_color')
	draw_circle(Vector2(), detection_radius, draw_color)

func _physics_process(delta: float) -> void:
	_exec_state(delta)
	move_actor()

func _exec_state(delta: float) -> void:
	match _state:
		0:
			# Triggered when the player enters its range
			var player := Game.get_player()
			if Geometry.is_point_in_circle(player.global_position, global_position, detection_radius):
				_state += 1
				direction = global_position.direction_to(player.global_position)
		1:
			# Charge at the player
			
			if _distance_met >= detection_radius:
				# Lerp velocity to zero
				velocity.x = lerp(velocity.x, 0, delta * 10)
				if is_zero_approx(velocity.x):
					direction.x = -direction.x
					_state += 1
					_distance_met = 0
			else:
				velocity.x = lerp(velocity.x, speed_cap.x * direction.x, delta * 5)
		2:
			# Move back into position
			
			var dest : Vector2 = get_meta('initial_position')
			if Math.is_almost_equal(global_position.x, dest.x, 0.003):
				if Math.is_almost_zero(velocity.x):
					global_position = dest
					velocity.x = 0
					timer.start()
					_state += 1
				else:
					velocity.x = lerp(velocity.x, 0, delta * 30)
			else:
				velocity.x = lerp(velocity.x, 50.0 * direction.x, delta * 10)
		3:
			# Wait a bit
			if is_zero_approx(timer.time_left):
				_state = 0

func move_actor():
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for i in get_slide_count():
		var slide := get_slide_collision(i)
		_distance_met += abs(slide.travel.x)

func set_detection_radius(r: float):
	detection_radius = r
	update()
