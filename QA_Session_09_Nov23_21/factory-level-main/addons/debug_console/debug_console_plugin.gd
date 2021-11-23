tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type('StringCommand', 'Reference', preload('res://addons/debug_console/StringCommand.gd'), load('res://addons/debug_console/Reference.svg'))
	
	add_autoload_singleton('History', 'res://addons/debug_console/History.gd')
	
	add_custom_type('DebugConsoleInsancer', 'Control', preload('res://addons/debug_console/debug_console_instancer.gd'), load('res://addons/debug_console/Reference.svg'))
	
	add_tool_menu_item('Instance Debug Console', self, '_instance_debug_console')
	
	add_tool_menu_item('Instance Debug Overlay', self, '_instance_debug_overlay')

func _exit_tree() -> void:
	remove_custom_type('StringCommand')
	
	remove_custom_type('DebugConsoleInsancer')
	
	remove_tool_menu_item('Instance Debug Console')
	
	remove_tool_menu_item('Instance Debug Overlay')

func _instance_debug_console(_ud) -> void:
	var root : Node = get_tree().edited_scene_root
	var node : Node = preload('res://addons/debug_console/DebugConsole.tscn').instance()
	root.add_child(node)
	node.owner = root

func _instance_debug_overlay(_ud) -> void:
	var root : Node = get_tree().edited_scene_root
	var node : Node = preload('res://addons/debug_console/DebugOverlay.tscn').instance()
	root.add_child(node)
	node.owner = root
