extends ProgressBar

@export var max_distance: float = 1000.0

func _ready():
	set_process(true)  

func _process(_delta):
	
	if Statics.player == null or Statics.snail == null:
		return

	var dist = Statics.player.global_position.distance_to(Statics.snail.global_position)
	dist = clamp(dist, 0.0, max_distance)
	value = (1.0 - (dist / max_distance)) * 100.0
