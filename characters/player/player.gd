extends CharacterBody2D
class_name Player

@onready var item_doll = preload("res://dev_workspaces/ko/items/item_Doll.tscn")
@onready var item_skull = preload("res://dev_workspaces/ko/items/item_Skull.tscn")
@onready var item_wheel = preload("res://dev_workspaces/ko/items/item_Hamster_Wheel.tscn")
@onready var item_leaf = preload("res://dev_workspaces/ko/items/item_Leaves.tscn")
@onready var item_cap = preload("res://dev_workspaces/ko/items/item_Cap.tscn")

var items_in_range: Array = []
var item_bag : String

@export var base_speed: float = 500
@export_range(0, 1, 0.05) var carry_move_percentage: float = 0.75

signal killed
signal slow_changed(new_val: bool)

# This is a "property", which is the same as a normal 
# variable, but it has `get` and `set` methods
@export var slowed: bool = false:
	get():
		return slowed
	set(new_val):
		slowed = new_val
		slow_changed.emit(new_val)

func _physics_process(_delta: float) -> void:
	var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_vector * base_speed
	
	if slowed:
		velocity *= carry_move_percentage
		
	move_and_slide()

func kill():
	killed.emit()
	queue_free()




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if slowed:
			drop_item()
		else:
			if !items_in_range.is_empty():
				pickup_item(items_in_range.pick_random())

func pickup_item(item: Area2D) -> void:
	item_bag = item.item_name
	print("in bag pickup ", item_bag)
	item.queue_free()
	slowed = true

func drop_item() -> void:
	print("in bag drop ", item_bag)
	var item
	match item_bag:
		"Doll":
			item = item_doll.instantiate()
		"Skull":
			item = item_skull.instantiate()
		"Wheel":
			item = item_wheel.instantiate()
		"Cap":
			item = item_cap.instantiate()
		"Leaf":
			item = item_leaf.instantiate()
	item.position = position
	get_parent().add_child(item)
	slowed = false

func _on_pickup_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("item_drop"):
		items_in_range.append(area)
		print(items_in_range)

func _on_pickup_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("item_drop"):
		items_in_range.erase(area)
		print(items_in_range)
