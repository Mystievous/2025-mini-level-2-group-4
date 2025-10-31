extends CharacterBody2D
# class_name Snail

@export var speed: float = 60.0
@export var min_stop_distance: float = 2
@export var light_stop_delay: float = 0.2

var _player: Node2D
var _lit := false
var _light_timer := 0.0
var _killing := false  # one-shot guard so we don't trigger twice

const FLASHLIGHT_LAYER_MASK := 1 << 7  # layer 8
const PLAYER_LAYER_MASK := 1 << 1      # layer 2

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")

	# LightDetector hookup (already in your scene)
	if $LightDetector is Area2D:
		$LightDetector.monitoring = true
		$LightDetector.monitorable = true
		$LightDetector.collision_mask = FLASHLIGHT_LAYER_MASK
		if $LightDetector.has_signal("area_entered"):
			$LightDetector.area_entered.connect(_on_light_enter)
		if $LightDetector.has_signal("area_exited"):
			$LightDetector.area_exited.connect(_on_light_exit)

	# KillZone hookup (new)
	if $KillZone is Area2D:
		$KillZone.monitoring = true
		$KillZone.monitorable = true
		$KillZone.collision_mask = PLAYER_LAYER_MASK
		# Prefer body_entered so we detect the Player CharacterBody2D
		if $KillZone.has_signal("body_entered"):
			$KillZone.body_entered.connect(_on_killzone_body_entered)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
		if not is_instance_valid(_player):
			velocity = Vector2.ZERO
			move_and_slide()
			return

	# freeze while lit
	if _lit:
		_light_timer = light_stop_delay
	if _light_timer > 0.0:
		_light_timer -= delta
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# chase
	var to_player := _player.global_position - global_position
	var dist := to_player.length()
	if dist > min_stop_distance:
		velocity = (to_player / max(dist, 0.0001)) * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if velocity.length() > 0.1:
		rotation = velocity.angle()

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
	# Robust: either the player group or the player layer
	var hit_player := body.is_in_group("player")
	if not hit_player and body is CollisionObject2D:
		hit_player = (body.collision_layer & PLAYER_LAYER_MASK) != 0
	if hit_player:
		_killing = true
		# Switch to lose screen (it handles the jumpscare & buttons)
		call_deferred("_go_to_lose")

func _go_to_lose() -> void:
	get_tree().change_scene_to_file("res://levels/Lose/lose_screen.tscn")
