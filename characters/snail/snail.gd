extends CharacterBody2D
# class_name Snail

@export var speed: float = 60.0
@export var min_stop_distance: float = 2
@export var light_stop_delay: float = 0.2
@export var anim_fps: float = 6.0
@export var is_evil: bool = false

@export var normal_texture: Texture2D
@export var evil_texture: Texture2D

var _player: Node2D
var _lit := false
var _light_timer := 0.0
var _killing := false

# Animation state
var _frame_timer := 0.0
var _walk_frame := 0
var _row := 0          # 0=down,1=left,2=up,3=right
var _last_dir := Vector2.DOWN

const FLASHLIGHT_LAYER_MASK := 1 << 7   # layer 8
const PLAYER_LAYER_MASK := 1 << 1       # layer 2
const FRAMES_PER_ROW := 4
const ROWS := 4

@onready var _sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# player
	_player = get_tree().get_first_node_in_group("player")

	# textures (defaults if not set in inspector)
	if normal_texture == null:
		normal_texture = load("res://characters/snail/assets/Snail_Normal.png")
	if evil_texture == null:
		evil_texture = load("res://characters/snail/assets/Snail_Evil.png")

	_sprite.texture = is_evil ? evil_texture : normal_texture
	# ensure sheet layout
	_sprite.hframes = FRAMES_PER_ROW
	_sprite.vframes = ROWS
	_sprite.frame = 0

	# LightDetector hookup
	if $LightDetector is Area2D:
		$LightDetector.monitoring = true
		$LightDetector.monitorable = true
		$LightDetector.collision_mask = FLASHLIGHT_LAYER_MASK
		if $LightDetector.has_signal("area_entered"):
			$LightDetector.area_entered.connect(_on_light_enter)
		if $LightDetector.has_signal("area_exited"):
			$LightDetector.area_exited.connect(_on_light_exit)

	# KillZone hookup
	if $KillZone is Area2D:
		$KillZone.monitoring = true
		$KillZone.monitorable = true
		$KillZone.collision_mask = PLAYER_LAYER_MASK
		if $KillZone.has_signal("body_entered"):
			$KillZone.body_entered.connect(_on_killzone_body_entered)

func _physics_process(delta: float) -> void:
	# reacquire player if needed
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
		if not is_instance_valid(_player):
			velocity = Vector2.ZERO
			move_and_slide()
			_update_animation(delta)
			return

	# freeze while lit
	if _lit:
		_light_timer = light_stop_delay
	if _light_timer > 0.0:
		_light_timer -= delta
		velocity = Vector2.ZERO
		move_and_slide()
		_update_animation(delta)
		return

	# chase
	var to_player := _player.global_position - global_position
	var dist := to_player.length()
	if dist > min_stop_distance:
		var dir := to_player / max(dist, 0.0001)
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	if velocity.length() > 0.1:
		rotation = velocity.angle()

	_update_animation(delta)

func _on_light_enter(area: Area2D) -> void:
	if (area.collision_layer & FLASHLIGHT_LAYER_MASK) != 0:
		_lit = true

func _on_light_exit(_area: Area2D) -> void:
	var still_lit := false
	for a in $LightDetector.get_overlapping_areas():
		if (a.collision_layer & FLASHLIGHT_LAYER_MASK) != 0:
			still_lit = true
			break
	_lit = still_lit

func _on_killzone_body_entered(body: Node) -> void:
	if _killing:
		return
	var hit_player := body.is_in_group("player")
	if not hit_player and body is CollisionObject2D:
		hit_player = (body.collision_layer & PLAYER_LAYER_MASK) != 0
	if hit_player:
		_killing = true
		call_deferred("_go_to_lose")

func _go_to_lose() -> void:
	get_tree().change_scene_to_file("res://levels/Lose/lose_screen.tscn")

# -----------------------
# Animation from sheet
# rows: 0=down, 1=left, 2=up, 3=right
# -----------------------
func _update_animation(delta: float) -> void:
	var moving := velocity.length() > 0.01
	var dir := moving ? velocity.normalized() : _last_dir

	_row = _dir_to_row(dir)
	if moving:
		_last_dir = dir
		_frame_timer += delta
		if _frame_timer >= (1.0 / anim_fps):
			_frame_timer = 0.0
			_walk_frame = (_walk_frame + 1) % FRAMES_PER_ROW
	else:
		_walk_frame = 0  # idle shows first frame of the row

	_sprite.frame = _row * FRAMES_PER_ROW + _walk_frame

func _dir_to_row(d: Vector2) -> int:
	# decide primarily by the axis with larger magnitude
	if abs(d.x) > abs(d.y):
		return (d.x > 0.0) ? 3 : 1   # right : left
	else:
		return (d.y > 0.0) ? 0 : 2   # down : up

