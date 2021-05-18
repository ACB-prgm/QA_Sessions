extends Line2D


const MAX_POINTS := 20

onready var parent = get_parent()


func _ready():
	parent.call_deferred("remove_child", self)
	parent.get_parent().call_deferred("add_child", self)


func _process(delta):
	draw_trail()


func draw_trail():
	add_point(to_local(parent.global_position), 0)
	
	if get_point_count() > MAX_POINTS:
		remove_point(MAX_POINTS)
