extends Node

#func call_timed_func(delay: float, obj: Object, method: String, args: = []) -> void:
#	if delay <= 0.0:
#		push_error("delay parameter needs to be positive")
#		return
#	if not is_instance_valid(obj):
#		push_error("object parameter is NULL")
#		return
#	if method == "" or not obj.has_method(method):
#		push_error("invalid method \"%s\"" % method)
#		return
#	yield(get_tree().create_timer(delay), "timeout")
#	obj.callv(method, args)

func exit(code: int = 0, message: String = "") -> void:
	var error_info = ErrorInfo.new(code, message)
	_exit(error_info)

#static func is_equal_approx_comp(a, b) -> bool:
#	assert(typeof(a) == typeof(b), "parameters are not the same type")
#	match typeof(a):
#		TYPE_COLOR:
#			assert(b is Color, "parameter 'b' not a color")
#			return is_equal_approx(a.r, b.r) \
#				and is_equal_approx(a.g, b.g) \
#				and is_equal_approx(a.b, b.b)
#		_:
#			push_error("parameter types are not supported here")
#
#	return false

#static func get_cell_size() -> int:
#	return ProjectSettings.get_setting("world/2d/cell_size")

static func get_screen_size() -> Vector2:
	return Vector2(
		ProjectSettings.get_setting("display/window/size/width"),
		ProjectSettings.get_setting("display/window/size/height")
	)

static func print_fields(fields: Array) -> void:
	for i in fields:
		print(i.name, " = ", i.value)

func _exit(error_info: ErrorInfo) -> void:
	if error_info.code: error_info.print()
	get_tree().quit(error_info.code)

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
