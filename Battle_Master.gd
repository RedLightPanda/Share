class_name gameM extends Node

signal roll_initiative

var queue : Array = []
var player: Player_Gnoll
var enemy: Battle_Actor


func start_battle(actors: Array) -> void:
	queue = actors
	if actors.is_empty():
		print("No actors to start battle with.")
		return
	
	for actor in queue:
		actor.roll_initiative()
		
	queue.sort_custom(func(a:Battle_Actor, b: Player_Gnoll): return a.initiative > b.initiative)
	
func roll() -> void: 
	roll_initiative.emit()
