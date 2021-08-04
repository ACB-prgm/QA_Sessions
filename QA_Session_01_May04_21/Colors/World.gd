extends Node2D


onready var spawnAreas = $SpawnAreas.get_children()

var enemy_TSCN = preload("res://QA_Sessions/QA_Session_07_Aug04_21/Example_Harpuia/Enemy.tscn")


func _on_Timer_timeout():
	var enemy_ins = enemy_TSCN.instance()
	
	spawnAreas.shuffle()
	var spawnArea = spawnAreas[0]
	
	enemy_ins.global_position = spawnArea.gen_random_pos()
	add_child(enemy_ins)
