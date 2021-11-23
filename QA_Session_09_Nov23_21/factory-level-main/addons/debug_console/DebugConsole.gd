## Debug console
# @name DebugConsole
# @desc A debug console that you can use for general-purpose testing.
#
#       The recommended way to use this console is to put it under a @class CanvasLayer
#       node and hide it from the editor. Then make sure that whenever you want to show
#       the console, @function activate() is called. If done correctly, the console should
#       look something like this: @img{images/DebugConsole_img2.png}
extends Control

const StringCommand : Reference = preload('res://addons/debug_console/StringCommand.gd')
const ErrorInfo : Reference = preload('res://addons/debug_console/ErrorInfo.gd')

signal console_destroyed
signal console_command(code, args)

## A script which provides a list of user-defined commands for the console to parse.
# @type Script
# @desc There is a particular syntax when it comes to this script.
#       First, there needs to be an array called @i valid_commands: it should
#       be a constant, but using a mutable variable will not produce an error.
#       Second, there must be a variable named @i remote_nodes, and unlike the
#       previous must be editable. Third, there should be a variable called
#       @i parent_node: it shall accept a reference to this console node. To avoid
#       errors with types, you should make the variable Variant or @class Node. Lastly,
#       the script must extend from @class Node.
#
#       The @i valid_commands array has a particular structure that must be
#       respected. Each element is a nested array with three elements:
#       @code{[ String command, [?int param1 ... int paramN?], [?String param1 ... String paramN?]}@br
#       The first element is the name of a function which shall exist in the same script. Next
#       is a list of integers that denote parameter types: use a constant of @enum Variant.Type or -1
#       to make it a Variant. Finally, the third element is a list of parameter names which correspond
#       to the second element.
#
#       When a command is evaluated, a function of the same name is called with the parameters
#       pulled from the input box. Parameters are interpreted as strings by default unless they
#       take forms that are valid for other types, in which case they are converted to the appropriate
#       type. See below for a list of supported types and what kind of strings are converted. The
#       function is expected to return a String, event an empty one, as that return value is the
#       output of the command printed to the console.
#
#       Imagine you have a function that takes an int called @function test. The command of the same
#       same name will be called with the first parameter interpreted as an integer. Should the conversion
#       fail, an error is produced.
#
#       To see what types there are, type "/types" in the console window.
export(Script) var command_script

export(Array, NodePath) var remote_nodes

onready var input_field = $VBoxContainer/InputField
onready var output_box = $VBoxContainer/HBoxContainer/Output
onready var command_handler = $CommandHandler

const _BUILTIN_COMMANDS: = [
	['/help', []],
	['/types', []],
	['/print', [{ param = 'value', type = -1 }]],
	['/list_remote_nodes', []],
	['/exit', []]
]

var command_list: = []
var active: = false

func _ready():
	if not command_script:
		push_error("'command_script' property is null")
		return
	
	command_handler.set_script(command_script)
	
	if command_handler.get("valid_commands") == null:
		push_error("no 'valid_commands' array defined in command script")
		queue_free()
		return
	elif typeof(command_handler.get("valid_commands")) != TYPE_ARRAY:
		push_error("'valid_commands' not an array")
		queue_free()
		return
	
	for path in remote_nodes:
		var remote_node = get_node(path)
		(command_handler.remote_nodes as Array).push_back(remote_node)
	
	_init_command_map()
	output_box.add_keyword_color("Error", Color("#ff0000"))
	
	for type in ["variant", "bool", "float", "int", "nil", "string"]:
		output_box.add_keyword_color(type, Color("#8EA2FF"))
	output_box.add_keyword_color("vector2", Color("#43E44A"))
	set_process(false)

## Activates the debug console.
# @desc Call this once to activate the console. Pauses the scene tree and grabs focus.
func activate():
	History.current_index = History.history.size()
	show()
	set_process(true)
	get_tree().paused = true
	input_field.grab_focus()
	active = true

## Deactivates the debug console.
# @desc Call this function to hide the debug console and to unpause the scene tree.
func deactivate():
	hide()
	input_field.release_focus()
	set_process(false)
	get_tree().paused = false
	active = false
	emit_signal("console_destroyed")

func goto_history_line(offset: int):
	History.current_index = int( clamp(History.current_index + offset, 0,
	History.history.size()) )
	
	if not History.history.empty():
		input_field.text = History.get_history_line()
		input_field.call_deferred("set_cursor_position", 9999)
		input_field.grab_focus()

## Output text to the console.
# @desc Writes the string @a text to the console text window. If a text begins with
#       an at-sign it is interpreted as a message to be specially formatted.
#
#       @at argcount:X:Y -- Generates an error message about the number of arguments.
#       @i X is the number of arguments expected, and @i Y is the the number of arguments
#       received.
#
#       @at arrayneed:P:C -- Generates an error message about the array @i P does not
#       have enough data. (It expects @i C elements.)
#
#       @at error:MSG -- Generates an error message. @i MSG is the message to display.
func output_text(text: String) -> void:
	if not text:
		text = " "
	else:
		text = _parse_error_string(text)
	output_box.text = str(output_box.text, "\n", text)

## Processes a command.
# @desc Processes the command string @a text. If the string begins with a '/', it is
#       treated as a builtin command. An error is emitted if the command does not exist
#       in the database as it's configured.
#
#       Builtin Commands:
#
#       /help -- Display a list of supported commands@br
#       /types -- Displays all the supported data types@br
#       /print ARG -- Prints the @a ARG, interpreting as one of the supported data types@br
#       /exit -- Deactivates the console
func process_command(text: String) -> void:
	var args = _process_args(text)
	if args is String:
		output_text("@error:" + args)
		return
	if args.size() == 0: return
	
	var command_name: String = args.pop_front()
	
	if command_name.begins_with("/"):
		_process_builtin_command(command_name, args)
		return
	
	var idx: int = -1
	var command: StringCommand
	
	for i in command_list.size():
		command = command_list[i]
		if command.command_name == command_name:
			idx = i
			break
	
	if idx >= 0:
		var parsed_args = command.parse_args(args)
		
		if (parsed_args is ErrorInfo):
			output_text("Error: " + parsed_args.info)
			return
		
		output_text(command_handler.callv(command.command_name, parsed_args))
		return

	output_text("Error: command %s does not exist" % command_name)

func _process_args(commandline: String):
	var args := []
	
	var current_arg := ''
	var spaced_string := false
	var delmiter := ''
	
	var words := commandline.split(' ')
	for word in words:
		if word.empty(): continue
		
		var first_char : String = word[0]
		var last_char : String = word[-1]
		
		if first_char == '"' or first_char == "'":
			delmiter = first_char
			if last_char == delmiter:
				current_arg = word.substr(1, word.length() - 2)
				args.push_back(current_arg)
			else:
				spaced_string = true
				current_arg = (word as String).substr(1) + ' '
		elif last_char == delmiter:
			delmiter = ''
			spaced_string = false
			current_arg += word.substr(0, word.length() - 1)
			
			args.push_back(current_arg)
			#args.push_back(current_arg.trim_suffix(' '))
		else:
			if spaced_string:
				current_arg += " %s " % word
			else:
				args.push_back(word)
	
	if spaced_string:
		return "Invalid string argument '%s': No closing quote character." % current_arg
	
	return args

func _parse_error_string(s: String):
	if s == "": return
	var words: Array = s.split(":", false)
	
	match (words.pop_front() as String):
		"@argcount":
			s = "Error: expected {0} arguments but got {1}"
			s = s.format([words[0], words[1]])
		"@arrayneed":
			s = "Error: array '{0}' requires {1} elements"
			s = s.format([words[0], words[1]])
		"@error":
			s = "Error: " + PoolStringArray(words).join(' ')
		"@exit":
			s = "Exit Console"
			if not words.empty():
				var temp_string_array: = PoolStringArray(words)
				s += str("\n", temp_string_array.join("\n"))
				
			call_deferred("deactivate")
	
	return s

func _process_builtin_command(cmd: String, _args: Array):
	match cmd:
		"/help":
			if _args.size():
				output_text("Ignoring arguments")
			
			output_text("Commands:")
			
			for command in command_list:
				output_text(str("\t", command.command_as_string()))
			
			output_text("Builtin Commands:")
			
			for command_def in _BUILTIN_COMMANDS:
				var command := StringCommand.new(command_def[0], command_def[1])
				output_text(str("\t", command.command_as_string()))
			
		"/types":
			if _args.size():
				pass
			
			var lines: = [
				["bool", "values: true, false"],
				["int", "any whole number (e.g. 1)"],
				["nil", "values: null, nil"],
				["float", "any number with decimal (e.g. 1.05 or 1.0)"],
				["vector2", 'any pair of values surrounded in parenthese, like so: "(2, 5)"']
			]
			
			output_text("Parameter types:")
			
			for line in lines:
				output_text("\t%s --- %s" % [line[0], line[1]])
		"/print":
			if _args.size():
				var command: = StringCommand.new("/print", [
					{
						param = "var",
						type = -1
					}
				])
				
				var variant = command.parse_args(_args)[0]
				output_text(str(variant))
			else:
				output_text("Error: no argument provided")
		"/exit":
			deactivate()
		"/list_remote_nodes":
			var list := PoolStringArray()
			
			for node in command_handler.remote_nodes:
				list.append(str(node))
			
			output_text(list.join("\n"))
		_:
			output_text("Error: invalid command '%s'" % cmd)
	
	return true

# Builds a command map based on the commands available in command_script.
# A properly constructed command file will have the following properties:
#   Array remote_nodes
#   Node parent_node
#   const Array valid_commands
#
# 'valid_commands' is an array where each element contains a list of components
# to a command. Each list consists of three elements:
#   [ String command, [?int param1 ... int paramN?], [?String param1 ... String paramN?]
#   
# The first element "command" is a string that specifies the name of the command.
# The name of the command must correspond to the name of a method such that
# the call() function would work.
#
# The second element is a list of integers that are used to describe the parameters
# accepted by the command. The integers specify the expected type of each parameter.
# Index 0 corresponds to the first parameter, and so on.
# Accepted values are any of the constants from Variant.Type or -1 if the parameter
# is meant to be a variant.
#
# The third element is a list of strings giving the names of each parameter. It must
# have the same number of elements as the second element.
func _init_command_map():
	command_handler.parent_node = self
	for command in command_handler.valid_commands:
		var args: = []
		for i in (command[1] as Array).size():
			args.push_back({
				param = command[2][i],
				type = command[1][i]
			})
		var _command: = StringCommand.new(command[0], args)
		command_list.push_back(_command)
	
	command_list.sort_custom(StringCommand, "_compare")

func _process(_delta):
	if (get_tree().get_frame() & 7):
		get_tree().paused = true

func _on_InputField_text_entered(new_text: String) -> void:
	input_field.clear()
	process_command(new_text)
	
	var length: int = output_box.text.length()
	if length > 999:
		output_box.text.erase(0, length - 900)
	
	output_box.cursor_set_line(1000)
	History.append_history(new_text)

func _unhandled_key_input(event: InputEventKey) -> void:
	if not visible: return
	
	if event.is_action_pressed("ui_cancel"):
		deactivate()
		get_tree().set_input_as_handled()
		return
	
	match event.scancode:
		KEY_UP:
			if event.echo: return
			goto_history_line(-1)
			get_tree().set_input_as_handled()
		KEY_DOWN:
			if event.echo: return
			goto_history_line(1)
			get_tree().set_input_as_handled()

func _on_CloseButton_pressed() -> void: deactivate()
