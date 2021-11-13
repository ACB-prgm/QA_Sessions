extends Node2D



var current_checkpoint = 0
var player_TSCN = preload("res://QA_Sessions/QA_Session_03_May12_21/BasicPlayer/BasicPlayer.tscn")
var player_INS

onready var cp_nodes = $Checkpoints.get_children()
var checkpoints = {}


func _ready():
	for checkpoint in cp_nodes:
		checkpoints[checkpoint.checkpoint] = checkpoint.global_position
	spawn_player()


func spawn_player():
	player_INS = player_TSCN.instance()
	player_INS.global_position = checkpoints.get(current_checkpoint)
	add_child(player_INS)


func _input(event):
	if event.is_action_pressed("mouse_click"):
		player_INS.queue_free()
		spawn_player()


func _on_checkpoint_entered(cp):
	if cp > current_checkpoint:
		current_checkpoint = cp
