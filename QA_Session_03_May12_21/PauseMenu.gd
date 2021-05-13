extends ColorRect



func _ready():
	hide()


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		show_pause_menu()


func show_pause_menu():
	show()
	get_tree().paused = true


func hide_pause_menu():
	hide()
	get_tree().paused = false


func _on_Button_pressed():
	hide_pause_menu()
