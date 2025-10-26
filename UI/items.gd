extends Area2D
signal items_collected

func _ready() -> void:
	add_to_group("collectible")
	



# Called when something enters the item's area
func _on_Area2D_body_entered(body: Node) -> void:
	
	#check if player touched
	if "player" in body.name:
			#signal ItemTracker
		items_collected.emit()
				#remove the item from scene
		queue_free()
				
