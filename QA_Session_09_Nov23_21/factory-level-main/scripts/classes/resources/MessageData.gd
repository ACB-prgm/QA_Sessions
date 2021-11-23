tool
extends Resource
class_name MessageData

export var string_data: PoolStringArray setget set_data,get_data

func _init(data: PoolStringArray = []) -> void:
	if Engine.editor_hint: return
	set_data(data)

func _to_string() -> String: return "[MessageData:%d]" % get_instance_id()

func get_data() -> PoolStringArray: return string_data

func is_empty() -> bool: return string_data.empty()

func set_data(value: PoolStringArray) -> void:
	string_data = value
