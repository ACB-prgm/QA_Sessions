extends Resource

var code: int = 0
var info: String

func print() -> void:
	print("Error code %d. Info: %s" % [code, info])

func _init(_code: int, _info: String):
	code = _code
	info = _info
