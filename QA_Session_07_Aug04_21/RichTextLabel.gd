extends RichTextLabel


onready var textEdit = $TextEdit


func _on_TextEdit_text_changed():
	text = textEdit.text + " |"
	
	text = text.replace("fire", "[img=<100>]QA_Sessions/QA_Session_07_Aug04_21/RichTextTest/FireTexture.tres[/img]")
	
	bbcode_text = text
