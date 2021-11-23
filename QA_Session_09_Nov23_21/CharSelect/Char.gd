extends TextureRect


export var color = Color(1,1,1,1)
export var NAME = "Joe"
export var ATK = 10
export var DEF = 20

onready var button = $Button

signal is_focused(_NAME, _ATK, _DEF)


func _ready():
	modulate = color
	modulate.a = 0.3

func grab_focus():
	button.grab_focus()


func _on_Button_focus_entered():
	set_focus()


func _on_Button_focus_exited():
	set_focus(false)


func _on_Button_mouse_entered():
	set_focus()


func _on_Button_mouse_exited():
	set_focus(false)

func set_focus(focused=true):
	if focused:
		modulate.a = 1.0
		emit_signal("is_focused", NAME, ATK, DEF)
	else:
		modulate.a = 0.3

