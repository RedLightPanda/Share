class_name Battle_Actor extends Resource

@export var name:String
@export var texture : Texture2D
@export var stats: Base_stats

func _ready():
	GameM.roll_initiative.connect(_on_battle_initiatvie)

func _on_battle_initiatvie():
	var rng = RandomNumberGenerator.new()
	print(self.name, "rolled a:", rng.randi_range(1,100))
