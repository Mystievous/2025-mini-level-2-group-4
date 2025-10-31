class_name ItemManager

#signal item_changed(item: ItemBase)

#constructor ?
#this is called in inventory.gd's _init()
func _init(item: ItemBase):
	self.item = item

#passes the value from the "constructor" to here
var item: ItemBase:
	set(val):
		item = val
#		item_changed.emit(val)

func is_empty()-> bool:
	return item == ItemsList.EMPTY

func _to_string() -> String:
	return "Item: " + str(item)

func getTexture() -> Texture2D:
	return item.texture
