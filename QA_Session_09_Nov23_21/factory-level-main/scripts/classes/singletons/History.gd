extends Node

var max_history_size: int = 100
var history: PoolStringArray
var current_index: int = 0

func append_history(v: String) -> void:
	history.append(v)
	if history.size() > max_history_size:
		history.remove(0)
	current_index = history.size()

func get_history_line(idx: int = -1) -> String:
	if idx < 0: idx = current_index
	if idx >= history.size(): return ""
	return history[idx]
