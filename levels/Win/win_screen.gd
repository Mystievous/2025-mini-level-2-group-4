extends Control

@export var level_scene: PackedScene

@onready var grassBG = $tallGrassBG
@onready var grassMG = $tallGrassMG
@onready var grassFG = $tallGrassFG
@onready var ground = $dirt

@onready var skybox1 = $Skybox1
@onready var skybox2 = $Skybox2

@onready var snail = $SnailWin
@onready var player = $playerDancing

func restart_game() -> void:
	get_tree().change_scene_to_packed(level_scene)
	
func end_game() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	move_tiles()
	
func move_tiles():
	if (skybox1.position.y != -1080):
		skybox1.position.y -= 1
		
	if (skybox2.position.y != 0):
		skybox2.position.y -= 1
		
	if (grassBG.position.y >= -1088):
		grassBG.position.y -= 0.74
	
	if (grassMG.position.y >= -1128):
		grassMG.position.y -= 0.84
		
	if (grassFG.position.y != -1128):
		grassFG.position.y -= 1
	
	if (ground.position.y != -1128):
		ground.position.y -= 1
	
	if (snail.position.y > 816):
		snail.position.y -= 1
	
	if (player.position.y != 864):
		player.position.y -= 1
	
