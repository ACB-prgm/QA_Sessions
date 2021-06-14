extends Node2D


signal doorway_used(direction)
signal two_entered(one_entered)
signal two_exited(one_entered)
signal one_entered(two_entered)
signal one_exited(two_entered)

var one_entered = false
var two_entered = false


func _ready():
	$Area1/One_Label.hide()
	$Area2/Two_Label.hide()


func _on_Area2_body_entered(_body):
	emit_signal("two_entered", one_entered)
	two_entered = true


func _on_Area2_body_exited(_body):
	if !one_entered:
		emit_signal("doorway_used", 2)
	
	emit_signal("two_exited", one_entered)
	two_entered = false


func _on_Area1_body_entered(_body):
	emit_signal("one_entered", two_entered)
	one_entered = true


func _on_Area1_body_exited(_body):
	if !two_entered:
		emit_signal("doorway_used", 1)
	
	emit_signal("one_exited", two_entered)
	one_entered = false
