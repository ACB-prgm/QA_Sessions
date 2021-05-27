extends KinematicBody2D


var leader


func _ready():
	leader = get_parent()
	
	leader.call_deferred("remove_child", self)
	get_tree().root.call_deferred("add_child" ,self)


func _physics_process(delta):
	follow()


func follow():
	if leader.points and leader.points.size() == leader.MAX_POINTS:
		if global_position.distance_to(leader.global_position) > 200:
			global_position = leader.points.pop_front()
