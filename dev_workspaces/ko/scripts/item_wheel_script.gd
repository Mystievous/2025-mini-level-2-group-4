extends Area2D

@onready var item_sprite: Sprite2D = $Sprite2D
@export var item_name = "Wheel"

func get_item_texture() -> Texture2D:
	return item_sprite.texture

func get_item_name() -> String:
	return item_name

func _to_string() -> String:
	return get_item_name()
