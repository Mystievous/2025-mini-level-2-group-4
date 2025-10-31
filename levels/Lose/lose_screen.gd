extends Control

@export var level_scene: PackedScene

@onready var JScare = $Jumpscare
@onready var fade_rect = $fader
@onready var qButton = $QuitButton
@onready var rButton = $ReplayButton
@onready var JScareBG = $JScareBGGround
@onready var grass = $GrassTilemap
@onready var lamp1 = $lamp1
@onready var lamp2 = $lamp2
@onready var glow1 = $glow1
@onready var glow2 = $glow2

@onready var grass1 = $TallGrassTilemap1
@onready var grass4 = $TallGrassTilemap4
@onready var snail = $Snail

@onready var jumpscareSound = $JumpscareSound
@onready var BGMusic = $BGMusic

var game_over_active = false
var grass1start
var grass4start

func _ready() -> void:
	grass1start = grass1.position.x
	grass4start = grass4.position.x
	
	qButton.visible = false
	rButton.visible = false
	grass1.visible = false
	grass4.visible = false
	snail.visible = false
	
	fade_rect.visible = true
	fade_rect.modulate.a = 0.0
	await jumpscare()
	

func restart_game() -> void:
	get_tree().change_scene_to_packed(level_scene)

func end_game() -> void:
	get_tree().quit()

func fade_in(duration: float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, duration)
	await tween.finished

func fade_out(duration: float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)
	await tween.finished

func jumpscare():
	await fade_out(0.5)

	JScareBG.visible = true
	grass.visible = true
	JScare.visible = true
	lamp1.visible = true
	lamp2.visible = true
	glow1.visible = true
	glow2.visible = true
	JScare.play("jumpscare")
	play_jumpscare_sound(5.0, 2.4)
	
	await JScare.animation_finished

	await fade_in(1.0)
	JScareBG.visible = false
	grass.visible = false
	JScare.visible = false
	lamp1.visible = false
	lamp2.visible = false
	glow1.visible = false
	glow2.visible = false

	BGMusic.play()
	grass1.visible = true
	grass4.visible = true
	qButton.visible = true
	rButton.visible = true
	snail.visible = true
	game_over_active = true
	await fade_out(0.5)

func move_grass():
	grass1.position.x += 2
	grass4.position.x += 2
	
	if grass1.position.x >= grass1start + (64 * 4):
		grass1.position.x = grass1start
	
	if grass4.position.x >= grass4start + (64 * 4):
		grass4.position.x = grass4start
	

func _process(delta: float) -> void:
	if game_over_active:
		move_grass()

func play_jumpscare_sound(duration: float, delay: float):
	await get_tree().create_timer(delay).timeout
	jumpscareSound.play()
	await get_tree().create_timer(duration).timeout
	jumpscareSound.stop();
