class_name Player_Gnoll extends CharacterBody2D

#The Running is all that's left to put in.
@onready var  tilemap = get_tree().current_scene.find_child("TileMap")
@export var Inventory: Inv_Resource
@export var player_Stats: Base_stats

const walkSpeed : = 50
const runSpeed: = 100
#can move is temp until Dialogic is set up.
var can_move = true
var can_run = false
var current_dir = "none"
#region Random Encounter
#Envorment Detect > Works
var area : String = "":
	set(value):
		area = value
		#print_debug(area)

#step counter works now the number is reset throught the Stage manager manager and the Escape button.
var step_Size: int = 7
var distance_in_px : float = 0.0:
	set(value):
		distance_in_px = value
		var step = distance_in_px/step_Size
		%Distance.text = "%d" % step
		
		if step >=Global.stage_Manger.encounter_num:
			set_physics_process(false)
			
			Global.stage_Manger.save_Player_info(self)
			Global.stage_Manger.battle_Scene()
			
#endregion
func  _ready() -> void:
	await get_tree().create_timer(.2).timeout
	position = Global.stage_Manger.player_last_pos

func _process(_delta):
	pass

func Player():
	pass

func _physics_process(delta):
	var initial_pos = position
	
	movement(delta)
	
	distance_in_px += position.distance_to(initial_pos)
	update_tile()
	

func update_tile():
	var tiledata = tilemap.get_cell_tile_data(0,tilemap.local_to_map(position))
	if tiledata:
		area = tiledata.get_custom_data("Area")

#region Movement
func movement(_delta):
	if can_move:
		if Input.is_action_pressed(("ui_right")):
			current_dir = "right"
			Animation(1)
			velocity.x = walkSpeed
			velocity.y = 0
			if can_run == true:
				velocity.x = runSpeed
				velocity.y = 0
		elif Input.is_action_pressed(("ui_left")):
			current_dir = "left"
			Animation(1)
			velocity.x = -walkSpeed
			velocity.y = 0
			if can_run == true:
				velocity.x = -runSpeed
				velocity.y = 0
		elif Input.is_action_pressed(("ui_up")):
			current_dir = "north"
			Animation(1)
			velocity.y = -walkSpeed
			velocity.x = 0
			if can_run == true:
				velocity.y= -runSpeed
		elif Input.is_action_pressed(("ui_down")):
			current_dir = "south"
			Animation(1)
			velocity.y = walkSpeed
			velocity.x = 0
			if can_run == true:
				velocity.y = runSpeed
				velocity.x = 0
		else:
			velocity = Vector2.ZERO
			Animation(0)

		if Input.is_action_pressed("ui_run"):
			can_run = true
		elif Input.is_action_just_released("ui_run"):
			can_run = false

	move_and_slide()

func Animation(movements):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		if movements == 1 && can_run == false:
			anim.play("Walk_E")
		elif  movements == 0:
			anim.play("Idle_E")

	elif dir == "left":
		if movements == 1 && can_run == false:
			anim.play("Walk_W")
		elif  movements == 0:
			anim.play("Idle_W")
			
	elif dir == "south":
		if movements == 1 && can_run == false:
			anim.play("Walk_S")
		elif movements == 0:
			anim.play("Idle_S")
			
	elif dir == "north":
		if movements == 1 && can_run == false:
			anim.play("Walk_N")
		elif  movements == 0:
			anim.play("Idle_N")
#endregion
