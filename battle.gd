class_name Battle_Screen extends Node2D

var enemy : Battle_Actor = null:
	set(value):
		enemy = value
		if value != null:
			%Enemy.texture = value.texture
			
func _ready():
	load_Data()

func load_Data():
	enemy = Global.stage_Manger.get_enemy()
