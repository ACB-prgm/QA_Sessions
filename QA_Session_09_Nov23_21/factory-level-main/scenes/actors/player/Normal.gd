extends State

var goal_velocity : float

func physics_main(delta: float):
	var root : Actor = persistant_state
	goal_velocity = root.direction.x * root.speed_cap.x
	
	var motion_delta := delta * (200 if root.direction.x else 300)
	root.velocity.x = move_toward(root.velocity.x, goal_velocity, motion_delta)
