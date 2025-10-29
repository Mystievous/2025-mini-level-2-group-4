class_name ItemCollectable
extends Node2D

@onready var item_sprite: Sprite2D = $Sprite2D
#@onready var hitbox: Area2D = $Hitbox

var stack : ItemStack

func _ready() -> void:
	item_sprite.texture = stack.getTexture()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		stack = body.bag_inventory.add_item(stack)
		
		if stack.is_empty():
			queue_free()
		else:
			return
