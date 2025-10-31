class_name ItemBase

extends Resource

@export var item_name : String = ""
@export var texture : Texture2D

func _to_string() -> String:
	return item_name
