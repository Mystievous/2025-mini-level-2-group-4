extends CharacterBody2D
# class_name Snail

@export var speed: float = 60.0
@export var min_stop_distance: float = 2
@export var light_stop_delay: float = 0.2  # small buffer to avoid jitter at the edge of the cone

var _player: Node2D
var _lit := false
var _light_timer := 0.0

const FLASHLIGHT_LAYER_MASK := 1 << 7  # layer 8

func _ready() -> void:
	# Find player by group (whoever owns the player scene should have put it in "player")
	_player = get_tree().get_first_node_in_group("player")

	# Make sure our detector is set up (snail-only; no edits outside snail folder)
	if $LightDetector is Area2D:
		$LightDetector.monitoring = true
		$LightDetector.monitorable = true
		# only listen to layer 8 (flashlight cone)
		$LightDetector.collision_mask = FLASHLIGHT_LAYER_MASK
		if $LightDetector.has_signal("area_entered"):
			$LightDetector.area_entered.connect(_on_light_enter)
		if $LightDetector.has_signal("area_exited"):
			$LightDetector.area_exited.connect(_on_light_exit)

func _physics_process(delta: float) -> void:
	# reacquire player if needed (scene load order)
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
		if not is_instance_valid(_player):
			velocity = Vector2.ZERO
			move_and_slide()
			return

	# freeze while lit (with short delay for smoother edges)
	if _lit:
		_light_timer = light_stop_delay

	if _light_timer > 0.0:
		_light_timer -= delta
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# normal chase
	var to_player := _player.global_position - global_position
	var dist := to_player.length()
	if dist > min_stop_distance:
		velocity = (to_player / max(dist, 0.0001)) * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# face movement direction
	if velocity.length() > 0.1:
		rotation = velocity.angle()

func _on_light_enter(area: Area2D) -> void:
	# accept anything on layer 8 (player flashlight cone)
	if (area.collision_layer & FLASHLIGHT_LAYER_MASK) != 0:
		_lit = true

func _on_light_exit(_area: Area2D) -> void:
	# re-check overlaps so multiple areas don’t toggle us off early
	var still_lit := false
	for a in $LightDetector.get_overlapping_areas():
		if (a.collision_layer & FLASHLIGHT_LAYER_MASK) != 0:
			still_lit = true
			break
	_lit = still_lit
