extends Node2D


var enemy_TSCN = preload("res://QA_Sessions/QA_Session_01_May04_21/Colors/Enemy.tscn")


func _ready():
	pass
#	spawn_enemy()



func spawn_enemy():
	var enemy_ins = enemy_TSCN.instance()
	enemy_ins.connect("enemy_died", self, "_on_enemy_died")
	add_child(enemy_ins)



func _on_enemy_died():
	print("enemy died")
