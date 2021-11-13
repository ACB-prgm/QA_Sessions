extends Position2D



onready var tween = $Tween
onready var camera = $Camera2D
var player
var target

enum {
	SCENE,
	PLAYER
}
var STATE = PLAYER


func _ready():
	set_physics_process(false)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		match STATE:
			SCENE:
				STATE = PLAYER
				global_position = Vector2(1980, 1080)/2
				set_physics_process(false)
				zoom(Vector2(1,1))
			PLAYER:
				STATE = SCENE
				tween.start()
				zoom(camera.zoom/2)
				set_physics_process(true)
				


func zoom(new_zoom):
	tween.interpolate_property(camera, "zoom", camera.zoom, new_zoom, 
	0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()


func _physics_process(delta):
	global_position = target.global_position


func _on_Player_is_player(player):
	player = player
	target = player
