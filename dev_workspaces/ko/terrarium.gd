extends Node2D

@onready var cap: Sprite2D = $items/cap
@onready var leaf: Sprite2D = $items/leaf
@onready var doll: Sprite2D = $items/doll
@onready var wheel: Sprite2D = $items/wheel
@onready var skull: Sprite2D = $items/skull

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
		area.queue_free()
