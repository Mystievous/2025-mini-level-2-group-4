extends Control

@export var level_scene: PackedScene

@onready var fg1 = $tallGrassTilemapFG1
@onready var fg2 = $tallGrassTilemapFG2

@onready var bg1 = $tallGrassTilemapBG1
@onready var bg2 = $tallGrassTilemapBG2
@onready var bg3 = $tallGrassTilemapBG3

@onready var ground = $grassGroundTilemap
@onready var lamps = $lamps
@onready var glow = $glow
@onready var sky1 = $Sky1
@onready var sky2 = $Sky2

var fg1_start_x
var fg2_start_x
var bg1_start_x
var bg2_start_x
var bg3_start_x
var ground_start_x
var lamps_start_x
var glow_start_x

func _ready() -> void:
	fg1_start_x = fg1.position.x
	fg2_start_x = fg2.position.x
	bg1_start_x = bg1.position.x
	bg2_start_x = bg2.position.x
	bg3_start_x = bg3.position.x
	ground_start_x = ground.position.x
	lamps_start_x = lamps.position.x
	glow_start_x = glow.position.x
	
func move_tiles():
	fg1.position.x -= 2.0
	fg2.position.x -= 1.4
	bg1.position.x -= 1.00
	bg2.position.x -= 0.6
	bg3.position.x -= 0.3
	ground.position.x -= 1.0
	lamps.position.x -= 1.0
	glow.position.x -= 1
	sky1.position.x -= 0.05
	sky2.position.x -=0.05
	
	# reset positions when they've moved past their scaled tile width
	if fg1.position.x <= fg1_start_x - (64 * 2.7):
		fg1.position.x = fg1_start_x
		
	if fg2.position.x <= fg2_start_x - (64 * 2.2):
		fg2.position.x = fg2_start_x
		
	if bg1.position.x <= bg1_start_x - (64 * 1.7):
		bg1.position.x = bg1_start_x
		
	if bg2.position.x <= bg2_start_x - (64 * 1.3):
		bg2.position.x = bg2_start_x
		
	if bg3.position.x <= bg3_start_x - (64 * 1.0):
		bg3.position.x = bg3_start_x
		
	if ground.position.x <= ground_start_x - (64 * 2.0):
		ground.position.x = ground_start_x
	
	if lamps.position.x <= lamps_start_x - (64 * 5.0 * 2):
		lamps.position.x = lamps_start_x
	
	if glow.position.x <= glow_start_x - (64 * 5.0 * 2):
		glow.position.x = glow_start_x
	
	if sky1.position.x <= -1920:
		sky1.position.x += 1920 * 2
	
	if sky2.position.x <= -1920:
		sky2.position.x += 1920 * 2

func _process(_delta: float) -> void:
	move_tiles()

func start_game() -> void:
	get_tree().change_scene_to_packed(level_scene)
	
func end_game() -> void:
	get_tree().quit()
