extends Sprite


var projectile_TSCN = preload("res://QA_Sessions/QA_Session_03_May12_21/NostalgicLeafParabola/Projectile.tscn")


#func _ready():
#	get_tree().root.set_transparent_background(true)

func _physics_process(delta):
	look_at(get_global_mouse_position())
	shoot()


func shoot():
	if Input.is_action_just_pressed("shoot"):
		var projectile_ins = projectile_TSCN.instance()
		projectile_ins.global_position = $Position2D.global_position
		get_parent().call_deferred("add_child", projectile_ins)
		projectile_ins.apply_central_impulse(Vector2.RIGHT.rotated(rotation).normalized() * 2000)
