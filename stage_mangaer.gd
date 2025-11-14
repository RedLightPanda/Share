class_name stageManger extends Node

@export var world_2d: Node2D
@export var gui: Control
@export var player: CharacterBody2D
@export var battle_scene: String
@export var battle_Path: String
@export var main_UI: CanvasLayer

var current_2d_Scenes
var current_UI_Scenes
var scene_Name: String = ""
var encounter_num: int = 100:
	set(value):
		encounter_num = value
		%Encounter.text = str(value)
var area: String = "Grass"
var player_last_pos: Vector2 = Vector2(100,100)

var enemy_Library : Dictionary = {}
@export_dir var enmey_folder
var encounter : Dictionary = {
	"Grass": ["002"],
	"Desert": ["000","001"]
}

func _ready():
	Global.stage_Manger = self
	current_2d_Scenes = $"World2D/TestScene"
	player.reparent(current_2d_Scenes)
	randomize()
	encounter_num = randi_range(25,50)
	load_enemy_Info()

func save_Player_info(Player):
	area = Player.area
	player_last_pos = Player.position

func change_GUI(_new_scene: String, delete: bool = true, keep_running: bool = false):
	if current_UI_Scenes:
		if delete:
			current_UI_Scenes.queue_free()
		elif keep_running:
			current_UI_Scenes.visible = false
		else:
			gui.remove_child(current_UI_Scenes)
	var new = load(current_2d_Scenes)
	gui.add_child(new)
	current_UI_Scenes = new
	
func change_2d_Scene(new_scene_Name: String, new_scene: String, _target: String, delete: bool = true, keep_running: bool = false):
	if current_2d_Scenes:
		if player and player.get_parent() == current_2d_Scenes:
			current_2d_Scenes.remove_child(player)
	
		if delete:
			current_2d_Scenes.queue_free()
		elif keep_running:
			current_2d_Scenes.visible = false
		else:
			world_2d.remove_child(current_2d_Scenes)
	
	var new = load(new_scene).instantiate()
	world_2d.add_child(new)
	current_2d_Scenes = new
	scene_Name = new_scene_Name
	new.add_child(player)
	player.reparent(new)
	
func battle_Scene():
	change_2d_Scene(battle_scene, battle_Path,"",false,true)
	main_UI.visible = false
	player.visible = false
	encounter_num = randi_range(25,50)
	
func load_enemy_Info():
	var folder = DirAccess.open(enmey_folder)
	folder.list_dir_begin()
	var file_name = folder.get_next()
	
	while file_name != "":
		enemy_Library[file_name] = load(enmey_folder + "/" + file_name)
		file_name = folder.get_next()
		
func get_enemy(ID = "000") -> Battle_Actor:
	var enemy_file_name = encounter[area][randi()% encounter[area]. size()] + ".tres"
	return enemy_Library[enemy_file_name]
