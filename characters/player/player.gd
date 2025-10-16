extends CharacterBody2D
class_name Player

@export var base_speed: float = 500
@export_range(0, 1, 0.05) var carry_move_percentage: float = 0.75

signal killed
signal slow_changed(new_val: bool)

# This is a "property", which is the same as a normal 
# variable, but it has `get` and `set` methods
@export var slowed: bool = false:
	get():
		return slowed
	set(new_val):
		slowed = new_val
		slow_changed.emit(new_val)

func _physics_process(_delta: float) -> void:
	var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_vector * base_speed
	
	if slowed:
		velocity *= carry_move_percentage
	
	move_and_slide()

func kill():
	killed.emit()
	queue_free()
