extends Sprite



var tween = Tween.new()


func _ready():
	call_deferred("add_child", tween)
	
#	yield(get_tree().create_timer(2.0), "timeout")
#
#	tween.interpolate_property(get_material(), "shader_param/flash_amount", 
#	1.0, 0.0, 1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
#	tween.start()
