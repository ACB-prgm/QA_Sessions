extends Control


onready var char_container := $HBoxContainer
onready var name_label = $VBoxContainer/Label
onready var atk_label = $VBoxContainer/Label2
onready var def_label = $VBoxContainer/Label3

var selected_char := ""


func _ready():
	char_container.get_children()[0].grab_focus()





func _on_char_is_focused(_NAME, _ATK, _DEF):
	selected_char = _NAME
	name_label.text = "NAME: %s" % [_NAME]
	atk_label.text = "ATK: %s" % [_ATK]
	def_label.text = "DEF: %s" % [_DEF]
