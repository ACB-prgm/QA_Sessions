extends Reference
class_name VarRef

var type: int = TYPE_NIL setget ,get_type
var object setget set_object,get_object

func get_object(): return object

func get_type() -> int: return type

func set_object(o):
	object = o
	type = typeof(o)

func _init(o = null): set_object(o)

func _to_string() -> String: return str(object)
