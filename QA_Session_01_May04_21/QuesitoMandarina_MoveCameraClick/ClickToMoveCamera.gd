extends Camera2D


onready var tween = $Tween

export var area_movement = false


func _ready():
	Globals.player = self
	
	if area_movement:
		set_physics_process(false)

func _physics_process(delta):
	if Input.is_action_just_pressed("mouse_click"):
		global_position = get_global_mouse_position()


func move_to(destination):
	var eta = global_position.distance_to(destination) / 1000.0 # < this number will change depending on how big your game window size is! about 1/3 the length is good
	
	tween.interpolate_property(self, "global_position", 
	global_position, destination, eta, 
	Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
