extends RigidBody2D


var target

func _physics_process(delta):
	if target:
		add_central_force(target.global_position.direction_to(global_position))



func _on_ToolButton_pressed():
	self.apply_central_impulse(Vector2(500, 0))
