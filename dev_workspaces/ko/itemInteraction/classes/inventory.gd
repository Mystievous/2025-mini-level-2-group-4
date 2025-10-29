class_name Inventory

signal updated

const SIZE : int = 1

var item_bag : Array[ItemStack] = []

func _init() -> void:
	item_bag.append(ItemStack.new(ItemLists.EMPTY))

func add_item(new_item: ItemStack) -> ItemStack:
	if new_item.is_empty():
		return
	
	if item_bag[0].is_empty():
		item_bag[0].item = new_item.item
	
	updated.emit()
	
	return new_item

func remove_item() -> void:
	item_bag[0].item = ItemLists.EMPTY
	updated.emit()

func _to_string() -> String:
	var s = ""
	
	for stack in item_bag:
		s += str(stack) + "\n"
	
	return s
