class_name Inventory

#signal updated
var item_drop : PackedScene = preload("res://dev_workspaces/ko/itemInteraction/items/item_collectable.tscn")
var item_slot : ItemManager

func _init() -> void:
	item_slot = ItemManager.new(ItemsList.EMPTY)

func add_item(new_item: ItemManager) -> ItemManager:
	if new_item.is_empty():
		return
	
	if item_slot.is_empty():
		item_slot.item = new_item.item
	
#	updated.emit()
	
	return new_item

func drop_item(position: Vector2) -> ItemCollectable:
	if is_empty():
		return
	
	var spawned_item : ItemCollectable = item_drop.instantiate()
	spawned_item.currentItem = getItem()
	spawned_item.global_position = position
	
	return spawned_item

func remove_item() -> void:
	item_slot.item = ItemsList.EMPTY
#	updated.emit()

func _to_string() -> String:	
	return str(item_slot) + "\n"

func is_empty() -> bool:
	return item_slot.is_empty()

func getItem() -> ItemManager:
	return item_slot
