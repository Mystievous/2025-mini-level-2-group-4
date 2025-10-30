class_name ItemCollectable
extends Node2D

@export var useBase : ItemBase

@onready var item_sprite: Sprite2D = $Sprite2D
#@onready var hitbox: Area2D = $Hitbox

var currentItem : ItemManager

func _ready() -> void:
	item_sprite.texture = currentItem.getTexture()

func _on_hitbox_body_entered(body: CharacterBody2D) -> void:
	print("who enter")
	if body is Player:
		print("omg player hi")
		#stack = body.bag_inventory.add_item(stack)
		
		#if stack.is_empty():
		#	queue_free()
		#else:
	#		return
