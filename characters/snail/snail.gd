extends CharacterBody2D
# class_name Snail

@export var speed: float = 60.0
@export var min_stop_distance: float = 2
@export var light_stop_delay: float = 0.2   

var _player: Node2D
var _in_safe_light := false
var _light_timer := 0.0

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")

	# Make sure our detector actually detects
	if $LightDetector is Area2D:
		$LightDetector.monitoring = true
		$LightDetector.monitorable = true
		# Be permissive with mask so we see whatever layer lights use
		$LightDetector.collision_mask = 0x7FFFFFFF
		if $LightDetector.has_signal("area_entered"):
			$LightDetector.area_entered.connect(_on_light_enter)
		if $LightDetector.has_signal("area_exited"):
			$LightDetector.area_exited.connect(_on_light_exit)

func _physics_process(delta: float) -> void:
	# reacquire player if needed
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
		if not is_instance_valid(_player):
			velocity = Vector2.ZERO
			move_and_slide()
			return

	# freeze while lit (with small grace to prevent flicker)
	if _in_safe_light:
		_light_timer = light_stop_delay
	if _light_timer > 0.0:
		_light_timer -= delta
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# follow
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
	# safe light areas
	if area.is_in_group("safe_light"):
		_in_safe_light = true

func _on_light_exit(_area: Area2D) -> void:
	# check overlaps so multiple lights don’t toggle off early
	var still := false
	for a in $LightDetector.get_overlapping_areas():
		if a.is_in_group("safe_light"):
			still = true
			break
	_in_safe_light = still
