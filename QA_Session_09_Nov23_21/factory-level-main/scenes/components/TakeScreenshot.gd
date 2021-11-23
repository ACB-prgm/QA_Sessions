extends Node

signal screenshot_taken

export(String, FILE) var output_file := ''
export(float, 0.0, 1000.0, 0.1) var delay := 0.0

var timer : Timer

func _enter_tree() -> void:
	if delay > 0.0:
		timer = Timer.new()
		timer.one_shot = true
		timer.autostart = false
		timer.wait_time = delay
		add_child(timer)

func _ready() -> void:
	var file_dir : String
	var dir := Directory.new()
	
	# Expecting a file, not a directory
	file_dir = output_file
	if dir.dir_exists(file_dir):
		push_error("'%s' is a directory!" % file_dir)
		return
	
	# Directory not found
	file_dir = output_file.get_base_dir()
	if not dir.dir_exists(file_dir):
		push_error("The directory '%s' does not exist." % file_dir)
	
	# Start timer
	if is_instance_valid(timer):
		timer.start()
		yield(timer, 'timeout')
	
	call_deferred('_take_snapshot')

func _take_snapshot():
	var img : Image = get_viewport().get_texture().get_data()
	
	img.flip_y()
	
	var err := OK
	
	err = img.save_png(output_file)
	if err:
		push_error("Failed to write texture to '%s'" % output_file)
		return
	
	emit_signal('screenshot_taken')
