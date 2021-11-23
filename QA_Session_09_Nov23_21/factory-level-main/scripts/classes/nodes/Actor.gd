## Kinematic Actor type
# @desc  Extends the functionality of @class KinematicBody2D with gravity and a vector speed and velocity.
#        By default, the physics process handles gravity with linear interpolation.
#
#        In addition to the exported properties, there are some variables that you can access
#        that are not exported to the editor.
#        Here is a list of them:
#
#        @code float gravity_value = 98 @br
#        The maximum Y velocity the actor can have due to gravity. Defaults to the value of
#        physics/2d/default_gravity in the project settings.
#
#        @code Vector2 velocity = Vector2() @br
#        The current velocity of the actor. For the most part, this variable must be manually
#        updated, except that the Y component is affected by gravity every physics step.
tool
class_name Actor, "res://assets/textures/icons/Actor.svg"
extends KinematicBody2D

const GRAVITY_STEP: float = 13.4

## Speed cap of the actor
# @type   Vector2
# @desc   The max speed of the actor. As this property is not acted upon in @class Actor, it is
#         up to the programmer whether to use it. That being said, it is meant to be used to
# 		  cap the actor's speed, hence the name.
var speed_cap := Vector2()

onready var gravity_value: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var velocity: = Vector2.ZERO

## Enable/disable the @class Actor
# @desc  Call this function to enable or disable the actor.
#        Affects the visibility and collision of the actor.
#        The argument @a flag can be true or false; true to enable
#        the actor's collision and rendering, or false to disable it.
func enable_actor(flag: bool) -> void:
	visible = flag
	enable_collision(flag)

	if has_method("_enable_actor"):
		call("_enable_actor", flag)

## Enable/disabled collision
# @desc  Call this function to enable or disable the actor's collision.
#        The argument @a flag can be true or false; true to enable
#        the actor's collision, or false to disable it.
func enable_collision(flag: bool) -> void:
	if not flag:
		collision_layer = 0
		collision_mask = 0
	else:
		collision_layer = get_meta('collision_layer')
		collision_mask = get_meta('collision_mask')

## Returns the center of the actor
# @virtual
# @const
# @return   The center of the actor as a @type Vector2
# @desc     Call this function to return the center of the actor. In its base form,
#           this function returns an empty Vector2, but you can override it to return the actual
#           center of your actor.
func get_center() -> Vector2: return Vector2()

func _ready() -> void:
	if Engine.editor_hint:
		set_physics_process(false)
		set_process(false)

func _init() -> void:
	set_meta("collision_layer", collision_layer)
	set_meta("collision_mask", collision_mask)

func _enter_tree() -> void:
	if Engine.editor_hint:
		set_physics_process(false)
		set_process(false)

func _to_string(): return "[Actor:%d]" % get_instance_id()

func _set(property, value):
	match property:
		"speed_cap":
			speed_cap = value
		_:
			return false
	return true

func _get(property):
	match property:
		"speed_cap":
			return speed_cap

func _get_property_list():
	return [
		{
			name = "Actor",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			name = "speed_cap",
			type = TYPE_VECTOR2,
			usage = PROPERTY_USAGE_DEFAULT
		},
		{
			name = "disabled",
			type = TYPE_BOOL,
			usage = PROPERTY_USAGE_DEFAULT
		}
	]

func _physics_process(_delta):
	velocity.y = move_toward(velocity.y, gravity_value, GRAVITY_STEP)
