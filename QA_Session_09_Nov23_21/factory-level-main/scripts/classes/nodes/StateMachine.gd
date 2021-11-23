## Container and controller of states
# @desc  A StateMachine controls the state of an object, referred internally as the persistent state.
#        The state machine collects all its @class State children and compiles them
#        into an array. From there, they are accessible by functions like @function change_state.
#
#        It is necessary that you call @function change_state at least once before calling
#        @function state_physics or @function state_process.
#
#        While the @class StateMachine collects a list of its @class State children, it also
#        connects to a number of signals as well. The signals it connects to are as follows.
#
#        * state_change_request(int new_state) @br
#        Change to a different state. @a new_state is the index of the state to switch to.
#        This signal is deferred, that is, emitted at the next idle frame after all the physics steps
#        have been exhausted.
#
#        * state_parent_call(String name, Array args) @br
#        Invoke an action in the @class StateMachine parent. @br
#        If @a name is "disable" or "enable", disable or enable a portion of the
#        active state, respectively. Index 0 of @a args is a constant of @enum StateCallMode.
tool
class_name StateMachine
extends Node

## Path to the root node
# @type  NodePath
# @desc  The root node of the @class StateMachine. Referred by the @class State
#        children as the persistent state.
var root_node: NodePath

## Whether the @class StateMachine is paused or not
# @type   bool
# @setter set_paused
var paused := false setget set_paused

## Which part of a state to enable or disable
enum StateCallMode {
	PHYSICS, ## Run in the physics process
	PROCESS ## Run in the idle process
}

var user_data setget set_user_data
var do_physics: FuncRef
var do_process: FuncRef

var _states: = []
var _current_state: int = -1

func _dummy_state(_delta): pass

func _exit_tree() -> void:
	if Engine.editor_hint: return
	
	for s in _states:
		(s as Node).queue_free()

func _get(property: String):
	match property:
		'root_node':
			return root_node
		'paused':
			return paused

func _get_property_list() -> Array:
	return [
		{
			name = 'StateMachine',
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			name = 'root_node',
			type = TYPE_NODE_PATH,
			usage = PROPERTY_USAGE_DEFAULT
		},
		{
			name = 'paused',
			type = TYPE_BOOL,
			usage = PROPERTY_USAGE_DEFAULT
		}
	]

func _ready():
	if Engine.editor_hint: return
	
	for state in get_children():
		assert(state is State)
		var s: State = state
		s.connect('state_change_request', self, "_change_state", [], CONNECT_DEFERRED)
		s.connect('state_parent_call', self, '_state_parent_call')
		_states.append(s)

func _set(property: String, value) -> bool:
	match property:
		'root_node':
			root_node = value
		'paused':
			paused = value
		_:
			return false
	return true

## Change to a different state
# @desc  Call this function to switch to a different state in the machine. @a next_state
#        is the index of the state you wish to go to. The states are in the same order
#        as they appear in the editor, starting from zero.
#
#        Before switching to a new state, the old state's @function cleanup method is invoked.
#        Then after switching to the new state, its @function setup method is invoked.
func change_state(next_state: int) -> int:
	var old_state = _current_state
	if next_state < 0 or next_state >= _states.size():
		push_error(str("invalid index ", next_state))
		return ERR_PARAMETER_RANGE_ERROR

	# Call the cleanup function of the old state
	if old_state >= 0:
		(_states[old_state] as State).cleanup()

	# Call the setup function of the new state
	_current_state = next_state

	# Reference the physics and idle functions before initializing state
	var temp: State = _states[_current_state]
	do_physics = funcref(temp, "physics_main")
	do_process = funcref(temp, "process_main")
	temp.setup(get_node(root_node), user_data)

	return OK

## Get the current state
func current_state() -> int: return _current_state

func set_paused(value: bool) -> void:
	paused = value

# Set the user data forwarded to the state
# @desc  @a udata can be any type. The user data is forwarded to the
#        state when it is initialized.
func set_user_data(udata) -> void: user_data = udata

# Call a state-specific method
# @desc  Calls @a method in the current state, provided it exists. @a args
#        are forwarded to @a method.
func state_call(method: String, args: Array = []):
	if paused: return
	var result
	var state: State = _states[_current_state]
	if state.has_method(method):
		result = state.callv(method, args)
	return result

## Go to the state's physics method
func state_physics(delta: float):
	if paused: return
	assert(do_physics.is_valid())
	return do_physics.call_func(delta)

## Go to the state's process method
func state_process(delta: float):
	if paused: return
	assert(do_process.is_valid())
	return do_process.call_func(delta)

# Signal callbacks

func _change_state(new_state: int):
	change_state(new_state)

func _state_parent_call(n: String, args: Array) -> void:
	match n:
		"disable":
			if args[0] == StateCallMode.PHYSICS:
				do_physics = funcref(self, '_dummy_state')
			elif args[0] == StateCallMode.PROCESS:
				do_process = funcref(self, '_dummy_state')
		"enable":
			if args[0] == StateCallMode.PHYSICS:
				do_physics = funcref(self, 'physics_main')
			elif args[0] == StateCallMode.PROCESS:
				do_process = funcref(self, 'process_main')
