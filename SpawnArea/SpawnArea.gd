tool
extends CollisionShape2D


onready var spawnArea = shape.extents
onready var origin = global_position - spawnArea


func gen_random_pos():
	var x = rand_range(origin.x, spawnArea.x)
	var y = rand_range(origin.y, spawnArea.y)
	
	return Vector2(x, y)


func _get_configuration_warning():
	return null
	update_configuration_warning()


var tween: Tween = tween.new()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		tween.interpolate_property()
		get_global_mouse_position()
