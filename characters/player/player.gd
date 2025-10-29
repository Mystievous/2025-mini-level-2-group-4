extends CharacterBody2D
class_name Player

var item_drop : PackedScene = preload("res://dev_workspaces/ko/itemInteraction/items/item_collectable.tscn")

@export var base_speed: float = 500
@export_range(0, 1, 0.05) var carry_move_percentage: float = 0.75

signal killed
signal slow_changed(new_val: bool)

var bag_inventory : Inventory = Inventory.new()

# This is a "property", which is the same as a normal 
# variable, but it has `get` and `set` methods
@export var slowed: bool = false:
	get():
		return slowed
	set(new_val):
		slowed = new_val
		slow_changed.emit(new_val)

func _physics_process(_delta: float) -> void:
	
	####TEST START DONT FORGET TO REMOVE
	if Input.is_action_just_pressed("interact"):
		bag_inventory.add_item(ItemStack.new(ItemLists.ITEM1))
		print(bag_inventory)
	
	if Input.is_action_just_pressed("drop"):
		drop_item()
		print(bag_inventory)
	####TEST END DONT FORGET TO REMOVE
	
	var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = move_vector * base_speed
	
	if slowed:
		velocity *= carry_move_percentage
	
#	make the player look at the mouse
	look_at(get_global_mouse_position())
	move_and_slide()

func kill():
	killed.emit()
	queue_free()

func drop_item() -> void:
	if bag_inventory.is_empty():
		return
	var spawned_item : ItemCollectable = item_drop.instantiate()
	spawned_item.stack = bag_inventory.getItem()
	spawned_item.global_position = global_position
	get_tree().current_scene.add_child(spawned_item)
	bag_inventory.remove_item()
	
