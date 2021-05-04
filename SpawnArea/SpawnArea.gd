extends CollisionShape2D


onready var spawnArea = shape.extents
onready var origin = global_position - spawnArea


func gen_random_pos():
	var x = rand_range(origin.x, spawnArea.x)
	var y = rand_range(origin.y, spawnArea.y)
	
	return Vector2(x, y)
