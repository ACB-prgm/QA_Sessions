extends Node2D


onready var spawnArea = $SpawnArea

var enemy_TSCN = preload("res://QA_Session_1/QA_Session_01/Colors/Enemy.tscn")


func _on_Timer_timeout():
	var enemy_ins = enemy_TSCN.instance()
	enemy_ins.global_position = spawnArea.gen_random_pos()
	add_child(enemy_ins)
