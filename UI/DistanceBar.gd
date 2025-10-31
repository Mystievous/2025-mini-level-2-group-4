extends ProgressBar

@export var max_distance: float = 1000.0

func _process(_delta):
	# Check if the globals are set
	if Statics.player == null:
		print("⚠️ Player not found")
		return
	if Statics.snail == null:
		print("⚠️ Snail not found")
		return

	# Debug their positions
	print("✅ Player:", Statics.player.global_position, " Snail:", Statics.snail.global_position)

	# Get positions
	var player_pos = Statics.player.global_position
	var snail_pos = Statics.snail.global_position

	# Calculate distance
	var dist = player_pos.distance_to(snail_pos)
	dist = clamp(dist, 0, max_distance)

	# Convert to percentage
	var progress_value = (1.0 - (dist / max_distance)) * 100.0
	value = progress_value
	
