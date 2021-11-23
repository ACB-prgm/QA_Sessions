tool
extends AnimationTree

export var start := false setget set_start

func set_start(v: bool):
	start = v
	if start:
		_reset_graph_position()
		call_deferred('set_script', null)

func _reset_graph_position() -> void:
	var root = tree_root
	if root is AnimationNodeStateMachine:
		root.set_graph_offset(Vector2())
