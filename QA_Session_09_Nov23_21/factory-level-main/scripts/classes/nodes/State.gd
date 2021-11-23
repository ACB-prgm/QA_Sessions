## A self-contained state, to be used with @class StateMachine
extends Node
class_name State

## Indicates that the state should be changed.
# @arg  int  new_state  An integer denoting the desired state
# @desc                 The @class StateMachine reacts to this signal and
#                       changes to the state indiciated by @i new_state.
signal state_change_request(new_state)

## A signal that gets communicated to the @class StateMachine parent and causes it to do something.
# @arg  String  name  A string used to identify the call
# @arg  Array   args  A list of arguments to pass to the function
# @desc               The @class StateMachine parent will connect to this signal automatically.
#                     What happens next depends on the @a name parameter. (See the documentation
#                     for @class StateMachine for details).
signal state_parent_call(name, args)

var persistant_state: Object
var user_data

# warning-ignore-all:shadowed_variable

## Called just before exiting the state.
# @virtual
func cleanup() -> void: pass

## Gets a meta value or a default on failure.
# @const
# @desc   If the meta field @a name exists, that is returned; otherwise
#         @a default is returned.
func get_meta_or_default(name: String, default = null):
	if has_meta(name):
		return get_meta(name)
	return default

## Should be called during the physics step.
# @virtual
# @desc    Override this method to implement custom physics-step behavior.
func physics_main(_delta: float): pass

## Should be called during the idle step.
# @virtual
# @desc    Override this method to implement custom idle-step behavior.
func process_main(_delta: float): pass

## Called on the first frame of a state.
# @desc  Call this function to initialize the state.
#        @a persistant_state is the persistent state, that is, the object which
#        this state modifies. @a user_data is forwarded to the state and can be
#        used by it.
#
#        @b{Note:} if the method @function _setup is defined, it is called
#        right at the end of this function. So it can be used to implement
#        state-specific initialization.
func setup(persistant_state, user_data = null) -> void:
	self.persistant_state = persistant_state
	self.user_data = user_data
	if has_method("_setup"): call("_setup")
