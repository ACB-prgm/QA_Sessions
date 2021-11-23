tool
extends Node

export var start := false setget set_start

var _animation_tree: AnimationTree

func set_start(v: bool):
	start = v
	if start:
		var temp = get_parent()
		if not (temp is AnimationTree):
			push_error("Node is not an AnimationTree")
			start = false
			return
		_animation_tree = temp
		_remove_transitions()
		queue_free()

func _remove_transitions():
	var tree_root = _animation_tree.tree_root
	if tree_root is AnimationNodeStateMachine:
		var root: AnimationNodeStateMachine = tree_root
		for i in root.get_transition_count():
#			var end_node: String = root.get_transition_to(i)
#			var start_node: String = root.get_transition_from(i)
#			print("transition %d connects %s to %s" % [i, start_node, end_node])
			root.remove_transition_by_index(0)
			print("removing transition %d" % i)
