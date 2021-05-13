extends Panel


const options = [
	"res://QA_Sessions/QA_Session_03_May12_21/NeiPodam/Panels/Balck.tres",
	"res://QA_Sessions/QA_Session_03_May12_21/NeiPodam/Panels/Gray.tres",
	"res://QA_Sessions/QA_Session_03_May12_21/NeiPodam/Panels/Red.tres"
]

var index := 0 setget set_index


func _on_DownButton_pressed():
	self.index -= 1


func _on_UpButton_pressed():
	self.index += 1
	

func set_index(new_value):
	
	index = new_value
	
	if index > options.size() - 1:
		index = 0
	elif index < 0:
		index = options.size() - 1
	
	set("custom_styles/panel", load(options[index]))
