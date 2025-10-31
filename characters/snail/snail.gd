extends CharacterBody2D
# class_name Snail

@export var speed: float = 60.0 # snail speed
@export var min_stop_distance: float = 2 

var _player: Node2D

func _ready() -> void:
	# Find player by group
	_player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	# If the player wasn’t ready at _ready() time (scene load order), try to find them again
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
		if not is_instance_valid(_player):
			velocity = Vector2.ZERO
			move_and_slide()
			return

	# chase vector towards the player
	var to_player := _player.global_position - global_position
	var dist := to_player.length()

	if dist > min_stop_distance:
		var dir := to_player / dist
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# snail faces its movement direction
	if velocity.length() > 0.1:
		rotation = velocity.angle()
