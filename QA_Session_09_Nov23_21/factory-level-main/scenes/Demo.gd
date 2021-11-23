extends Node2D

var debug_overlay
var explorer

func _ready() -> void:
	explorer = $Explorer
	debug_overlay = $DebugOverlay
	debug_overlay.add_stat("Distance Travelled", $GuardRobot, '_distance_met', false)
	debug_overlay.add_stat("Velocity", $GuardRobot, 'velocity', false)

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed('reset'):
		$EnergyBall.set_rigid_position(Vector2(248, 350))
