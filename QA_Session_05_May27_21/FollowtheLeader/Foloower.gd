extends KinematicBody2D


var leader


func _ready():
	leader = get_parent()
	
	leader.call_deferred("remove_child", self)
	get_tree().root.call_deferred("add_child" ,self)


func _physics_process(delta):
	follow()


func follow():
	var points = leader.curve.get_baked_points()
	if points:
		var point = points[0]
		if global_position.distance_to(leader.global_position) > 200:
			global_position = point
			points.remove(0)
#		elif global_position.distance_to(leader.global_position) <= 200:
#			leader.points.clear()
