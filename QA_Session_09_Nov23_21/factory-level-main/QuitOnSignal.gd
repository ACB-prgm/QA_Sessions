extends Node

export var node_path : NodePath
export var node_signal : String
export(int, 0, 4) var node_signal_arg_count := 0

func _ready() -> void:
	if node_signal.empty():
		push_error("No signal name provided")
		queue_free()
		return
	
	var node = get_node(node_path)
	if node:
		var int2str := PoolStringArray(['zero', 'one', 'two', 'three', 'four'])
		var funcname := "_signal_callback_with_%s_args" % int2str[node_signal_arg_count]
		node.connect(node_signal, self, funcname, [], CONNECT_DEFERRED)

func _signal_callback_with_zero_args() -> void: _quit()

func _signal_callback_with_one_args(_arg1) -> void: _quit()

func _signal_callback_with_two_args(_arg1, _arg2) -> void: _quit()

func _signal_callback_with_three_args(_arg1, _arg2, _arg3) -> void: _quit()

func _signal_callback_with_four_args(_arg1, _arg2, _arg3, _arg4) -> void: _quit()

func _quit() -> void: get_tree().quit()
