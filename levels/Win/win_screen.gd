extends Control

@export var level_scene: PackedScene

@onready var button_sound: AudioStreamPlayer = %ButtonSound

func restart_game() -> void:
	if button_sound.playing:
		return
	button_sound.play()
	await button_sound.finished
	get_tree().change_scene_to_packed(level_scene)
	
func end_game() -> void:
	if button_sound.playing:
		return
	button_sound.play()
	await button_sound.finished
	get_tree().quit()
