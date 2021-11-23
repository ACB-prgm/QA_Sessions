tool
extends Node
class_name ActionQueue

class Action:
	var type: String
	var params: Array

var action_definitions := []

func _get(property: String):
	match property:
		"action_definitions":
			return action_definitions

func _get_property_list() -> Array:
	return [
		{
			name = "ActionQueue",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			name = "action_",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			name = "action_definitions",
			type = TYPE_ARRAY,
			usage = PROPERTY_USAGE_DEFAULT
		}
	]
