extends Node2D


enum {
	IDLE
	ATTACK
	FOLLOW
	DEFEND
}

var STATE = IDLE


func _physics_process(delta):
	match STATE:
		IDLE:
			pass
		ATTACK:
			pass
		FOLLOW:
			pass
		DEFEND:
			pass
