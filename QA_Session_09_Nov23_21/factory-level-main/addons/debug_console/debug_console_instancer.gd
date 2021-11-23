tool
extends Control

func _ready() -> void:
	call_deferred('instance_node')

func instance_node() -> void:
	var root : Node = get_tree().edited_scene_root
	var node : Control = preload('res://addons/debug_console/DebugConsole.tscn').instance()
	root.add_child(node)
	node.owner = root
	
#	queue_free()
