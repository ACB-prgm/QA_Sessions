extends KinematicBody2D

const MAX_FOLLOW_DISTANCE = 800
const MIN_FOLLOW_DISTANCE = 200
const MAX_VEL = 1000
const ACCELERATION = 50

var velocity = Vector2.ZERO

onready var leader_path = get_parent()
onready var tween = $Tween


func _ready():
	yield(Globals, "global_player_set")
	global_position = Vector2(int(global_position.x), int(global_position.y))
	for x in range(global_position.x, int(Globals.player.global_position.x)):
		Globals.player.points.append(x)


func _physics_process(_delta):
	follow()


func follow():
#	global_position = Globals.player.points[0]
	if Globals.player.points:
		tween.interpolate_property(self, "global_position", global_position, Globals.player.points[0], 
		.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
