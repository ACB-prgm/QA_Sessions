## Debug overlay
# @name DebugOverlay
extends CanvasLayer

onready var debug_label : Label = $PanelContainer/DebugLabel

var stats: = []
var blocked: = false

## Adds a stat to the overlay.
# @desc Displays information about a stat on the debug overlay. @a stat_ref is a path to
#       a property or the name of a method inside @a object. Specify whether it is a method
#       or not with @a is_method. @a stat_name is the display name of the stat.
func add_stat(stat_name: String, object: Object, stat_ref: String, is_method: bool) -> void:
	if blocked: return
	stats.append([stat_name, object, stat_ref, is_method])

## Remove a stat from the overlay.
# @desc Removes a stat from the overlay indicated by @a stat_name. It is the same name
#       as was used in @function add_stat.
func remove_stat(stat_name: String) -> void:
	if blocked: return
	
	for s in stats:
		if (s[0] as String) == stat_name:
			blocked = true
			call_deferred("_remove_stat", s)

func _remove_stat(val):
	blocked = false
	stats.erase(val)

func _process(_delta):
	var label_text = ""
	
	if true:
		var fps = Engine.get_frames_per_second()
		var mem = OS.get_static_memory_usage()
		
		label_text = "FPS: %s\nStatic Memory Usage: %s\n" \
			% [fps, String.humanize_size(mem)]
	
	for s in stats:
		var value = null
		if s[1] and is_instance_valid(s[1]):
			if s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])
		else:
			remove_stat(s[0])
		label_text += str(s[0], " : ", value, "\n")
	
	debug_label.text = label_text
