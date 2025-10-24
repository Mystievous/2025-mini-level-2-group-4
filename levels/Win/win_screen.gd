extends Control

@export var level_scene: PackedScene

func restart_game() -> void:
	get_tree().change_scene_to_packed(level_scene)
	
func end_game() -> void:
	get_tree().quit()
