extends Node2D

@onready var parent: Player = get_parent()

@export var animated_sprite: AnimatedSprite2D
@export var pause_when_idle: bool = true

@export var empty_frames: SpriteFrames
@export var full_frames: SpriteFrames

@export_custom(PROPERTY_HINT_NONE, "suffix:seconds") var animation_debounce_time: float = 0.05

@export_category("Debug")
@export var draw_debug_lines = false

var debounce_timer: Timer

var target_animation: String

const directions: Dictionary[String, Vector2] = {
	"up-right": (Vector2.UP * 2) + Vector2.RIGHT,
	"up-left": (Vector2.UP * 2) + Vector2.LEFT,
	"down-right": (Vector2.DOWN / 2) + Vector2.RIGHT,
	"down-left": (Vector2.DOWN / 2) + Vector2.LEFT,
}

func _ready() -> void:
	debounce_timer = Timer.new()
	debounce_timer.wait_time = animation_debounce_time
	debounce_timer.timeout.connect(_apply_animation)
	add_child(debounce_timer)
	
	animated_sprite.play()
	
	parent.slow_changed.connect(on_slow_changed)
	
func on_slow_changed(value: bool):
	var animation := animated_sprite.animation
	var frame := animated_sprite.frame
	var progress := animated_sprite.frame_progress
	animated_sprite.sprite_frames = full_frames if value else empty_frames
	animated_sprite.play(animation)
	animated_sprite.set_frame_and_progress(frame, progress)

func _physics_process(_delta: float) -> void:
	_check_animation()

func _get_closest_animation(move_angle: float) -> String:
	
	var floats: Dictionary[String, float] = {}
	
	for key in directions.keys():
		floats[key] = absf(angle_difference(move_angle, directions[key].normalized().angle()))
	
	var closest_angle_animation: String
	var closest_angle_value: float
	
	for key in directions:
		if not closest_angle_animation:
			closest_angle_animation = key
			closest_angle_value = floats[key]
			continue
		
		if floats[key] < closest_angle_value:
			closest_angle_animation = key
			closest_angle_value = floats[key]
			
	return closest_angle_animation

func _check_animation() -> void:	
	var move_angle := parent.velocity.angle()

	if parent.velocity.is_zero_approx():
		if pause_when_idle:
			animated_sprite.stop()
		return
	
	var closest_animation := _get_closest_animation(move_angle)
			
	if target_animation != closest_animation:
		target_animation = closest_animation
		debounce_timer.start()
		
	if not animated_sprite.is_playing():
		animated_sprite.play()
	
func _apply_animation() -> void:
	var frame := animated_sprite.frame
	var progress := animated_sprite.frame_progress
	animated_sprite.play(target_animation)
	animated_sprite.set_frame_and_progress(frame, progress)

func _process(_delta: float) -> void:
	if draw_debug_lines:
		queue_redraw()

func _draw() -> void:
	if !draw_debug_lines:
		return
		
	var midpoints: Array[Vector2] = []
	
	for key in directions.keys():
		var vector := directions[key].normalized()
		
		draw_line(Vector2.ZERO, vector * 50, Color.RED)
		
		var curr := vector
		var steps = 0
		while steps < 360:
			if _get_closest_animation(curr.angle()) != key:
				midpoints.push_back(curr)
				break
			
			curr = curr.rotated(0.25 * PI / 180)
			steps += 1
	
	draw_line(Vector2.ZERO, parent.velocity / 5, Color.GREEN)
	
	for midpoint in midpoints:
		draw_line(Vector2.ZERO, midpoint * 25, Color.WEB_PURPLE)
	
	
	
