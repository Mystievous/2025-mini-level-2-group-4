extends Node2D

@onready var player: Player = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _set_intensity(value: float):
	FmodServer.set_global_parameter_by_name("Intensity", value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance := player.global_position.distance_to(global_position)
		
	FmodServer.set_global_parameter_by_name("Intensity", -(distance / 1250) + 1)
