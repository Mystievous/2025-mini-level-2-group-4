class_name Inventory

signal updated

const SIZE : int = 1

var item_slot : Array[ItemStack] = []


func _init() -> void:
	item_slot.append(ItemStack.new(ItemLists.EMPTY))

func add_item(new_item: ItemStack) -> ItemStack:
	if new_item.is_empty():
		return
	
	if item_slot[0].is_empty():
		item_slot[0].item = new_item.item
	
	updated.emit()
	
	return new_item

func remove_item() -> void:
	item_slot[0].item = ItemLists.EMPTY
	updated.emit()

func _to_string() -> String:
	var s = ""
	
	for stack in item_slot:
		s += str(stack) + "\n"
	
	return s

func is_empty() -> bool:
	return item_slot[0].is_empty()

func getItem() -> ItemStack:
	return item_slot[0]
