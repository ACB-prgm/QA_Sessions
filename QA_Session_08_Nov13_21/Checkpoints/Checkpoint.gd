extends Sprite


export var checkpoint := 0

signal checkpoint_entered(cp)


func _on_Area2D_body_entered(body):
	emit_signal("checkpoint_entered", checkpoint)
