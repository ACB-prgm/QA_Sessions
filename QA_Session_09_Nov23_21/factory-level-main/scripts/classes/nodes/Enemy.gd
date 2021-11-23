## An enemy actor type
tool
extends Actor
class_name Enemy, "res://assets/textures/icons/Enemy.svg"

# TODO: add documentation

## The stats of the @class enemy
# @type Stats
var stats: Stats

## The amount of time the @class Enemy is invincible after taking damage
# @type float
var armor_time: float = 1.0

var invincibility_timer: Timer

var direction: = Vector2.LEFT

func _enter_tree():
	if Engine.editor_hint: return
	invincibility_timer = Timer.new()
	invincibility_timer.one_shot = true
	invincibility_timer.wait_time = armor_time
	add_child(invincibility_timer)

func _get(property):
	match property:
		"armor_time":
			return armor_time
		"stats":
			return stats

func _get_property_list():
	return [
		{
			name = "Enemy",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			name = "armor_time",
			type = TYPE_REAL,
			usage = PROPERTY_USAGE_DEFAULT,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.1,10,0.1,or_greater"
		},
		{
			name = "stats",
			type = TYPE_OBJECT,
			usage = PROPERTY_USAGE_DEFAULT,
			hint = PROPERTY_HINT_RESOURCE_TYPE,
			hint_string = "Resource"
		}
	]

func _ready():
	if Engine.editor_hint: return
	assert(is_instance_valid(stats), "Enemy needs a 'stats' property")
	stats.init_stats(self)
	
	for node in get_children():
		if node is Area2D:
			node.set_meta("owner", self)

func _set(property, value):
	match property:
		"armor_time":
			armor_time = value
		"stats":
			stats = value
		_:
			return false
	return true

## Called to decide the amount of damage to take based on the attacker's stats
# @arg other_stats The Stats belonging to an opposing actor
func decide_damage(other_stats: Stats) -> void:
	if not should_damage(): return
	var dmg = stats.calculate_damage(other_stats)
	stats.health = int(max(0, stats.health - dmg))
	if has_method("_on_damaged"):
		call("_on_damaged", other_stats)

## Calculates the enemy's direction and distance to the player
# @return  A dictionary with the direction and distance to the player, or null
#          if the player does not exist inside the tree
func direction_to_player():
	if Game.has_player():
		var player: Actor = Game.get_player()
		var distance := player.get_center() - get_center()
		return {distance = distance, direction = distance.normalized()}

## Returns the current health
# @return  The health of the @class Enemy
func get_health() -> int: return stats.health

## Returns a metadata value with a default as fallback
# @arg    name     The key for which a metadata is defined
# @arg    default  The default return value if @a name does not exist
# @return          The metadata for @a name (if it exists) or @a default otherwise
func get_meta_or_default(name: String, default = null):
	if has_meta(name):
		return get_meta(name)
	return default

## Returns true if the @class Enemy should take damage
# @virtual
# @return  True if the Enemt should take damage, false otherwise
# @note    This function is called by @function decide_damage; if this returns
#          true, the @class Enemy takes damage according to the Stats of the other Actor.
func should_damage() -> bool:
	var result: bool = invincibility_timer.is_stopped()
	if has_method("_should_damage"):
		result = result && call("_should_damage")
	return result
