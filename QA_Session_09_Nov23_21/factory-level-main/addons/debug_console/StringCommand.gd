extends Reference

const ErrorInfo : Reference = preload('res://addons/debug_console/ErrorInfo.gd')

const ARG_TYPES: = [TYPE_ARRAY, TYPE_BOOL, TYPE_INT, TYPE_NIL, TYPE_REAL, TYPE_VECTOR2, TYPE_OBJECT]

const TYPE_NAMES: = {
	TYPE_ARRAY: "array",
	TYPE_BOOL: "bool",
	TYPE_INT: "int",
	TYPE_NIL: "nil",
	TYPE_REAL: "float",
	TYPE_VECTOR2: "vector2",
	TYPE_STRING: "string",
	TYPE_OBJECT: "object",
	-1: "variant"
}

var command_name: String
var param_names: Array
var param_types: Array
var param_defaults: Array
var param_count: int

func command_as_string() -> String:
	var result: = command_name
	
	for i in range(param_count):
		var _temp_arg = " (%s %s)" % [TYPE_NAMES[param_types[i]], param_names[i]]
		
		if param_defaults[i]:
			_temp_arg = (_temp_arg as String).insert(_temp_arg.length() - 1,
			str("= ", param_defaults[i]))
		
		result += (_temp_arg as String)
	
	return result

func create_command(name: String, args: Array = []):
	for arg in args:
		var _temp
		
		# Parameter name.
		_temp = (arg as Dictionary).get("param")
		if not _temp:
			push_error("command '%s', argument %d missing 'param' field" \
			% [name, param_count])
			return
		
		param_names.push_back(_temp)
		
		# Parameter type.
		_temp = (arg as Dictionary).get("type")
		if not _temp:
			push_error("command '%s', argument %d missing 'type' field" \
			% [name, param_count])
			return
		
		param_types.push_back(_temp)
		
		# Parameter default value.
		_temp = (arg as Dictionary).get("default")
		if _temp:
			param_defaults.push_back(_temp)
		else:
			param_defaults.push_back(null)
		
		param_count += 1
	
	command_name = name

static func get_type(s: String) -> int:
	for _type in ARG_TYPES:
		if is_valid_type(s, _type):
			return _type
	
	return TYPE_STRING

static func get_type_name(type: int) -> String: return TYPE_NAMES.get(type, "unknown")

static func is_valid_type(s: String, type: int) -> bool:
	var regex: = RegEx.new()
	
	match type:
		TYPE_ARRAY:
			assert(not regex.compile("\\[(\\s*[_0-9a-zA-Z\\.]+,?)*\\]"))
			return true if regex.search(s) else false
		TYPE_BOOL:
			return (s == "true" or s == "false")
		TYPE_INT:
			assert(not regex.compile("0[xX][a-fA-F0-9]+"))
			
#			if s.is_valid_hex_number(true): return true
			
			var valid_hex: bool = true if regex.search(s) else false
			if valid_hex:
				s = String(s.hex_to_int())
				return true
			
			return s.is_valid_integer()
		TYPE_NIL:
			return (s == "nil" or s == "null")
		TYPE_REAL:
			return s.is_valid_float()
		TYPE_STRING:
			return true
		TYPE_VECTOR2:
			assert(not regex.compile("\\(-?[0-9]{1,},-?[0-9]{1,}\\)"))
			var regex_match = regex.search(s)
			return true if regex_match else false
	
	return false

func parse_args(args: Array = []):
	var count: int = int(min(param_count, args.size()))
	
	if count != param_count:
		return ErrorInfo.new(ERR_PARAMETER_RANGE_ERROR,
		"expected %d args but got %d\n%s" % [param_count, count, command_as_string()])
	
	for i in count:
		var arg = args[i]
		var type = get_type(arg)
		
		match type:
			TYPE_INT:
				# Add decimal to integer-representing string.
				if param_types[i] == TYPE_REAL:
					arg = (arg as String) + ".0"
					type = TYPE_REAL
			TYPE_REAL:
				# Truncate decimal from float-representing string.
				if param_types[i] == TYPE_INT:
					var _arg = arg as String
					var idx = _arg.find(".")
					_arg.erase(idx, _arg.length() - idx)
					type = TYPE_INT
					arg = _arg
			TYPE_STRING:
				if (arg as String) == "''":
					arg = ""
		
		# Error if the deduced type doesn't match the argument's.
		if param_types[i] >= 0 and type != param_types[i]:
			return ErrorInfo.new(ERR_INVALID_PARAMETER,
			"invalid parameter '%s', expected %s but got %s" \
			% [param_names[i], get_type_name(param_types[i]), get_type_name(type)])
		
		args[i] = str2val(arg, type)
	
	return args

static func str2val(s: String, type: int):
	# Error if 's' is not valid to the selected type.
	if not is_valid_type(s, type):
		push_error('cannot convert "%s" into %s' % [s, get_type_name(type)])
		return s
	
	match type:
		TYPE_ARRAY:
			var _regex: = RegEx.new()
			assert(not _regex.compile("[_0-9a-zA-Z\\.]+"))
			
			var matches = _regex.search_all(s)
			var result: = []
			
			for m in matches:
				var _temp_element = (m as RegExMatch).get_string()
				var _type = get_type(_temp_element)
				
				if _type != TYPE_STRING:
					_temp_element = str2val(_temp_element, _type)
				
				result.push_back(_temp_element)
			
			return result
		TYPE_BOOL:
			return true if s == "true" else false
		TYPE_INT:
			return s.hex_to_int() if s.is_valid_hex_number(true) else s.to_int()
		TYPE_NIL:
			return
		TYPE_REAL:
			return s.to_float()
		TYPE_VECTOR2:
			var vec: = Vector2()
			
			var _regex: = RegEx.new()
			assert(not _regex.compile("-?[0-9]+"))
			
			var reg_match: RegExMatch
			reg_match = _regex.search(s)
			vec.x = reg_match.get_string().to_float()
			
			reg_match = _regex.search(s, reg_match.get_end())
			vec.y = reg_match.get_string().to_float()
			return vec
		TYPE_STRING:
			pass
		var inv:
			push_error("invalid type code %d" % inv)
	
	return s

static func _compare(e, v):
	if e.command_name.nocasecmp_to(v.command_name) < 0:
		return true
	return false

func _init(name: String, args: Array = []):
	create_command(name, args)
