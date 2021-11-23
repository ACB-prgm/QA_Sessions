extends Resource
class_name Stats

export(int, 1, 500) var max_health: int = 5
export(int, 0, 500) var max_mana: int = 0
export(int, 1, 100) var attack: int = 1
export(int, 0, 100) var defense: int = 0
export var owner_name: = ""

var health: int = 0
var mana: int = 0

func calculate_damage(other_stats: Stats) -> int:
	var result = max(0, other_stats.attack - defense)
	return int(result)

func get_meta_or_default(name: String, default = null):
	if has_meta(name):
		return get_meta(name)
	return default

func init_stats(owner: Object):
	health = max_health
	mana = max_mana
	set_meta("owner", owner)

func _to_string():
	if not owner_name.empty():
		return "[Stats for %s]" % owner_name
	return "[Stats:%d]" % get_instance_id()
