extends ScrollContainer


onready var container = $VBoxContainer

func _print(text):
	var lbl = Label.new()
	lbl.text = str(text)
	container.add_child(lbl)
