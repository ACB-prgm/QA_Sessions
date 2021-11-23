extends Node

var parent_node: Node
var remote_nodes: = []
var initial_position: = Vector2()

const valid_commands: = [
#	["kevin_speed", [-1, -1], ["x", "y"]],
#	["kevin_velocity", [TYPE_VECTOR2], ["velocity"]],
#	["kevin_animation", [TYPE_STRING, TYPE_REAL], ["animation", "speed"]],
#	["math_map_range", [TYPE_REAL, TYPE_REAL, TYPE_REAL, TYPE_REAL, TYPE_REAL],
#		['value', 'imin', 'imax', 'omin', 'omax']],
	
	["delete_node", [TYPE_INT], ["iid"]],
	["list_actor_ids", [], []],
	["new_actor", [-1, TYPE_VECTOR2], ["actor_id", "spawn_pos"]],
	["reset_position", [], []],
	["reset_scene", [], []],
	["set_position", [], []]
]

func delete_node(iid: int) -> String:
	var inst := instance_from_id(iid)
	if not is_instance_valid(inst):
		return "@error:%d does not refer to a valid instance" % iid
	
	(inst as Node).queue_free()
	
	return str("Deleted ", inst)

func list_actor_ids() -> String:
	var result := ""
	for id in Game.ActorIDS:
		result += str(id, "\n")
		#result += str(id, " = ", Game.actor_id_to_string(id), "\n")
	return result

func new_actor(id, pos: Vector2) -> String:
	if (id is String):
		id = Game.ActorIDS.get(id, -1)
	elif not (id is int):
		return "@error:invalid parameter %s, must be an integer or string" % id
	
	var result := ""
	
	var scene = Game.Scenes.get(id)
	if not is_instance_valid(scene):
		result = "@error:no actor with ID %d exists" % id
	else:
		var instance = (scene as PackedScene).instance()
		var parent: Node = get_node('/root/Main')
		assert( is_instance_valid(parent), "not in CharacterTest.tscn!" )
		
		var player = Game.get_player()
		assert(player, "where is the player?")
		parent.add_child(instance)
		parent.move_child(instance, player.get_index())
		
		instance.global_position = pos
		result = "Spawn new %s (IID: %d) at position %s" \
					% [Game.actor_id_to_string(id), instance.get_instance_id(), pos]
	
	return result

func reset_position() -> String:
	var kevin : Actor = Game.get_player()
	kevin.global_position = initial_position
	return str("reset Kevin's position to ", initial_position)

func reset_scene() -> String:
	get_tree().call_deferred('reload_current_scene')
	return "@exit"

func set_position() -> String:
	var kevin : Actor = Game.get_player()
	initial_position = kevin.global_position
	return "Saved position: %s" % initial_position

#func kevin_speed(x, y) -> String:
#	var result: String
#	var kevin: Actor = parent_node.get_node(remote_nodes[0])
#
#	match typeof(x):
#		TYPE_INT:
#			kevin.speed_cap.x = float(x)
#			result = str("set X speed cap to ", x, "\n")
#		TYPE_REAL:
#			kevin.speed_cap.x = x
#			result = str("set X speed cap to ", x, "\n")
#		TYPE_STRING:
#			if x == "-":
#				result = "Set X component to the default, which is %s\n" % Game.default_kevin_speed.x
#				kevin.speed_cap.x = Game.default_kevin_speed.x
#			else:
#				result = "Leave X component to its initial value of %s\n" % kevin.speed_cap.x
#		_:
#			return "@error:invalid parameter '%s'" % x
#
#	match typeof(y):
#		TYPE_INT:
#			kevin.speed_cap.y = float(y)
#			result += str("set Y speed cap to ", y)
#		TYPE_REAL:
#			kevin.speed_cap.y = y
#			result += str("set Y speed cap to ", y)
#		TYPE_STRING:
#			if y == "-":
#				result += "Set Y component to the default, which is %s" % Game.default_kevin_speed.y
#				kevin.speed_cap.y = Game.default_kevin_speed.y
#			else:
#				result += "Leave Y component to its initial value of %s" % kevin.speed_cap.y
#		_:
#			return "@error:invalid parameter '%s'" % y
#
#	return result

#func kevin_velocity(velocity: Vector2) -> String:
#	var kevin: Actor = parent_node.get_node(remote_nodes[0])
#	if kevin.is_on_floor():
#		return "@error:Kevin must be in the air for this to work."
#	kevin.velocity = velocity
#	return str("Set Kevin's velocity to ", velocity)

#func kevin_animation(animation: String, speed: float) -> String:
#	var kevin: Actor = parent_node.get_node(remote_nodes[0])
#	var animation_player: AnimationPlayer = kevin.get_node("AnimationPlayer")
#
#	if not animation_player.has_animation(animation):
#		return "@error:no animation called \"%s\"" % animation
#
#	animation_player.play(animation, -1, speed)
#
#	return "playing animation '%s' at %f speed" % [animation, speed]

#func math_map_range(value: float, imin: float, imax: float, omin: float, omax: float) -> String:
#	var mapped_value := range_lerp(value, imin, imax, omin, omax)
#	return "map %f to [%f,%f]: %f" % [value, omin, omax, mapped_value]
