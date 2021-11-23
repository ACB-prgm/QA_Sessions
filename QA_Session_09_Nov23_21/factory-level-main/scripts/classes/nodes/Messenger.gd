## An actor that can display a dialog message.
tool
extends Actor
class_name Messenger

## Dialogic timeline
# @type String
var timeline := ""

## Root node to which the dialog is added
# @type NodePath
var root_node: NodePath

var _root: Node2D

func _enter_tree() -> void:
	update_configuration_warning()

func _ready() -> void:
	if Engine.editor_hint: return
	var temp = get_node(root_node)
	if temp and (temp is Node2D):
		_root = temp

func _get(property: String):
	match property:
		"timeline":
			return timeline
		"root_node":
			return root_node

func _set(property: String, value) -> bool:
	match property:
		"timeline":
			timeline = value
			update_configuration_warning()
		"root_node":
			root_node = value
			update_configuration_warning()
		_:
			return false
	return true

func _get_property_list() -> Array:
	return [
		{
			name = "Messenger",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			name = "timeline",
			type = TYPE_STRING,
			usage = PROPERTY_USAGE_DEFAULT
		},
		{
			name = "root_node",
			type = TYPE_NODE_PATH,
			usage = PROPERTY_USAGE_DEFAULT
		}
	]

func _get_configuration_warning() -> String:
	var warnings := PoolStringArray([])
	
	if root_node.is_empty():
		warnings.push_back("No root node has been specified. You need a root node in order for the dialog box to be displayed.")
	if timeline.empty():
		warnings.push_back("No timeline has been specified. In order for Dialogic to work, you need to specify which timeline you want it to show.")
	return warnings.join("\n\n")

## Start a dialog message.
# @desc Instances a dialog box and adds it to the scene.
#       The dialog box loads the timeline specified by @a tm. If it is not provided
#       or is an empty string, @property timeline is used instead.
#
#       The dialog box is added to the scene tree under the node pointed to by
#       @property root_node. For this function to work, the @property root_node
#       property must point to a @class Node2D.
#
#       If a node inheriting from @class Messenger defines the private method
#       @function _on_dialogic_signal, then it gets linked to the @signal dialogic_signal
#       signal for the dialog box. The function must have a single parameter, an arbitrary
#       string value.
#func start_dialog(tm: String = "") -> void:
#	if tm.empty(): tm = timeline
#	var dlg = Dialogic.start(tm)
#	if is_instance_valid(_root) and _root.is_inside_tree():
#		_root.add_child(dlg)
#		dlg.connect("timeline_end", self, "_timeline_complete")
#		if has_method('_on_dialogic_signal'):
#			dlg.connect('dialogic_signal', self, '_on_dialogic_signal')
#		Game.set_dialog_mode(true)

# Signal callbacks

#func _timeline_complete(_tm):
#	Game.set_dialog_mode(false)
