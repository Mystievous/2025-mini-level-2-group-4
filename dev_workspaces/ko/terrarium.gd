extends Node2D

signal all_items_placed

@export var win_scene: PackedScene

@onready var cap: Sprite2D = $items/cap
@onready var leaf: Sprite2D = $items/leaf
@onready var doll: Sprite2D = $items/doll
@onready var wheel: Sprite2D = $items/wheel
@onready var skull: Sprite2D = $items/skull

var items_placed : int = 0 

func _process(_delta: float) -> void:
	if items_placed == 5:
		print("all items placed")
		all_items_placed.emit()
		get_tree().change_scene_to_packed(win_scene)
		items_placed += 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("item_drop"):
		match area.name:
			"Cap":
				cap.visible = true
			"Skull":
				skull.visible = true
			"HamsterWheel":
				wheel.visible = true
			"Leaves":
				leaf.visible = true
			"Doll":
				doll.visible = true
		items_placed += 1
		area.queue_free()
