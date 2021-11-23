## Measures the distances between two things
# @desc  This node measures the distance between itself and the node specified
#        by the @a other_node property.
#
#        What exactly gets measured depends on the @i component property. Either
#        the X or Y distance between two nodes can be checked, or both. Alternatively,
#        the linear distance between the two nodes can be checked.
tool
extends Node2D
class_name DistanceNotifier

## The other node is closer than @a threshold.
# @arg Node2D node The node that entered range
signal entered_range(node)

## The other node is farther away then @a threshold.
# @arg Node2D node The node that exited range
signal exited_range(node)

## Measure only the X distance
# @type int
const X_COMPONENT := 0

## Measure only the Y distance
# @type int
const Y_COMPONENT := 1

## Measure both the X and Y distances
# @type int
const BOTH_COMPONENTS := 2

## Calculate the linear difference between two nodes
# @type int
const FLOAT := 3

## The other node being measured.
# @type NodePath
# @setter set_other_node(v)
var other_node: NodePath = NodePath() setget set_other_node

## This determines what gets measures exactly.
# @type int
# @desc      Valid values are: @code X_COMPONENT, @code Y_COMPONENT,
#            @code BOTH_COMPONENTS, or @code FLOAT. @code X_COMPONENT and
#            @code Y_COMPONENT are obvious, but @code BOTH_COMPONENTS and
#            @code FLOAT need explaining.
#
#            With @code BOTH_COMPONENTS, both the X and Y component of @a threshold
#            are checked: the X and Y distance between two nodes both need to be
#            less than or equal to the threshold's X and Y component, respectively,
#            in order to be considered "within range".
#
#            With @code FLOAT, the linear distance between the two nodes is
#            calculated. Imagine a line between the connected nodes: the length
#            of that line is the distance being checked under this mode. In this
#            case, the X component of @a threshold is used as the threshold.
var component: int = X_COMPONENT

## Maximum distance between nodes
# @type   Vector2
# @setter set_threshold(value)
# @desc   What you put in here depends on @a component: if @code X_COMPONENT
#         or @code Y_COMPONENT, either the X component or the Y component
#         are used; if @code BOTH_COMPONENTS, both components are used; if
#         @code FLOAT, the X component is used to hold a linear distance.
#
#         In the case of @code FLOAT, the linear distance refers to the result
#         of @function{Vector2::distance}.
var threshold: Vector2 = Vector2() setget set_threshold

## The color of the line when out of range
# @type Color
# @setter set_editor_line_color(value)
var editor_line_color := Color.cadetblue setget set_editor_line_color

## The color of the line when in range
# @type Color
# @setter set_editor_line_color(value)
var editor_line_range_color := Color.pink setget set_editor_line_range_color

## Thickness of the line drawn between nodes
# @type float
# @setter set_editor_line_width(value)
var editor_line_width := 1.0 setget set_editor_line_width

## Radius of the circle
# @type float
# @setter set_editor_radius(value)
var editor_radius := 15.0 setget set_editor_radius

## Color of the circle
# @type Color
# @setter set_editor_circle_color(value)
var editor_circle_color := Color(0.65, 0.16, 0.16, 0.5) setget set_editor_circle_color

var _other_node: Node2D
var _distance_met := false

func _editor_check_distance() -> bool:
	_other_node = get_node(other_node)
	if not _check_valid_other_node():
		set_process(false)
		return false

	var other_position: Vector2 = get_meta('other_node_position')
	set_meta('other_node_position', _other_node.global_position)

	return (other_position != _other_node.global_position)

# Returns true if the other node is within *threshold*
func _check_distance_met() -> bool:
	var met := false
	match component:
		X_COMPONENT:
			var diff := (global_position - _other_node.global_position).abs().x
			met = diff < threshold.x
		Y_COMPONENT:
			var diff := (global_position - _other_node.global_position).abs().y
			met = diff < threshold.y
		BOTH_COMPONENTS:
			var diff := (global_position - _other_node.global_position).abs()
			met = (diff.x < threshold.x) and (diff.y < threshold.y)
		FLOAT:
			var diff := global_position.distance_to(_other_node.global_position)
			met = diff < threshold.x
		_:
			# Failsafe
			set_process(false)
	return met

func _check_valid_other_node() -> bool:
	var valid := is_instance_valid(_other_node)
	return valid

func _get(property: String):
	match property:
		"other_node":
			return other_node
		"component":
			return component
		"editor/line_color":
			return editor_line_color
		"editor/line_range_color":
			return editor_line_range_color
		"editor/line_width":
			return editor_line_width
		"editor/radius":
			return editor_radius
		"editor/circle_color":
			return editor_circle_color

func _get_configuration_warning() -> String:
	if other_node.is_empty():
		return "You need to specify a node to compare with"
	var temp = get_node_or_null(other_node)
	if not temp:
		return "The node path is invalid."
	if not(temp is Node2D):
		return "The node pointed to by the node path is invalid. It needs to be derived from Node2D."
	if threshold == Vector2.ZERO:
		return "The threshold is zero; the node will not take effect."
	return ""

func _get_property_list() -> Array:
	return [
		{
			name = "DistanceNotifier",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			name = "other_node",
			type = TYPE_NODE_PATH,
			usage = PROPERTY_USAGE_DEFAULT
		},
		{
			name = "component",
			type = TYPE_INT,
			usage = PROPERTY_USAGE_DEFAULT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = "X,Y,Both,Float"
		},
		{
			name = "threshold",
			type = TYPE_VECTOR2,
			usage = PROPERTY_USAGE_DEFAULT
		},
		{
			name = "editor/line_color",
			type = TYPE_COLOR,
			usage = PROPERTY_USAGE_DEFAULT
		},
		{
			name = "editor/line_range_color",
			type = TYPE_COLOR,
			usage = PROPERTY_USAGE_DEFAULT
		},
		{
			name = "editor/line_width",
			type = TYPE_REAL,
			usage = PROPERTY_USAGE_DEFAULT,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "1.0,50.0,0.1"
		},
		{
			name = "editor/radius",
			type = TYPE_REAL,
			usage = PROPERTY_USAGE_DEFAULT,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "5.0,50.0,0.1,or_greater"
		},
		{
			name = "editor/circle_color",
			type = TYPE_COLOR,
			usage = PROPERTY_USAGE_DEFAULT
		}
	]

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TRANSFORM_CHANGED:
			update()
		NOTIFICATION_PROCESS:
			if Engine.editor_hint:
				if _editor_check_distance():
					update()
				return
			var old_value := _distance_met
			_distance_met = _check_distance_met()
			if old_value != _distance_met:
				if _distance_met:
					emit_signal("entered_range", _other_node)
				else:
					emit_signal("exited_range", _other_node)
		NOTIFICATION_ENTER_TREE:
			if Engine.editor_hint:
				set_notify_transform(true)
				_other_node = get_node_or_null(other_node)
				set_meta('_other_node', _other_node)
				set_meta('other_node_position', Vector2.ZERO)
			set_process( _check_valid_other_node() )
		NOTIFICATION_READY:
			if not Engine.editor_hint:
				_other_node = get_node_or_null(other_node)
				var valid := _check_valid_other_node()
				set_process(valid)
				if valid:
					_distance_met = _check_distance_met()
		NOTIFICATION_DRAW:
			if Engine.editor_hint:
				draw_circle(Vector2.ZERO, editor_radius, editor_circle_color)

				if threshold != Vector2.ZERO:
					var node: Node2D = get_node_or_null(other_node)
					if not is_instance_valid(node): return

					# Check if within threshold
					var color := editor_line_color
					_other_node = node
					if _check_distance_met():
						color = editor_line_range_color
					_other_node = null

					var dest := node.global_position - global_position
					draw_line(Vector2.ZERO, dest, color, editor_line_width)

func _set(property: String, value) -> bool:
	match property:
		"other_node":
			set_other_node(value)
		"component":
			component = value
		"threshold":
			threshold = value
		"editor/line_color":
			set_editor_line_color(value)
		"editor/line_range_color":
			set_editor_line_range_color(value)
		"editor/line_width":
			set_editor_line_width(value)
		"editor/radius":
			set_editor_radius(value)
		"editor/circle_color":
			set_editor_circle_color(value)
		_:
			return false
	return true

## Returns the distance between this and the other node.
# @desc  This function checks the distance between this node and the one
#        referenced by @a other_node. The return valued is a Vector2 specifying
#        the positive distance between the two.
#
#        If @a other_node is empty or points to an
#        invalid node, Vector2() is returned and an error is emitted.
func get_vector() -> Vector2:
	if not _check_valid_other_node():
		push_error("No valid other node to compare with")
		return Vector2.ZERO
	
	var distance = (global_position - _other_node.global_position).abs()
	return distance

## Returns true if the other node is within range.
func is_within_range() -> bool: return _distance_met

func set_editor_circle_color(c: Color) -> void:
	editor_circle_color = c
	update()

func set_editor_line_color(lc: Color) -> void:
	editor_line_color = lc
	update()

func set_editor_line_range_color(lbc: Color) -> void:
	editor_line_range_color = lbc
	update()

func set_editor_line_width(w: float) -> void:
	editor_line_width = w
	update()

func set_editor_radius(rad: float) -> void:
	editor_radius = rad
	update()

## Set the @a other_node property.
# @desc  Sets the node to be measured by @class DistanceNotifier. If @a v is
#        a Node2D-derived type, the path is derived from its position in the tree.
func set_other_node(v) -> void:
	if v == null:
		set_meta('_other_node', null)
		set_meta('other_node_position', null)
		set_process(false)
		return

	if v is NodePath:
		other_node = v
		var temp = get_node_or_null(other_node)
		if is_instance_valid(temp) and temp is Node2D:
			_other_node = temp
	elif v is Node2D:
		if (v as Node2D).is_inside_tree():
			other_node = (v as Node).get_path()
			_other_node = v
	else:
		push_error("Parameter must be a NodePath or a Node2D")

	update()
	update_configuration_warning()

func set_threshold(t: Vector2) -> void:
	threshold = t.abs()
	update_configuration_warning()
	update()
