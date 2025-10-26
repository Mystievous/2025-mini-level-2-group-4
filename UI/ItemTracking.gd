extends Node
signal all_items_collected

@export var label_path: NodePath = ^"Label"  
@export var total_items: int = 0
var items_collected: int = 0

func _ready():
	# If no total is given, count all nodes in the "collectible" group
	if total_items <= 0:
		total_items = get_tree().get_nodes_in_group("collectible").size()

	# Connect each collectible's signal
	for item in get_tree().get_nodes_in_group("collectible"):
		if item.has_signal("item_collected"):  
			item.item_collected.connect(_on_item_collected)

	_update_label()


# Called when an item is collected
func _on_item_collected():  
	items_collected += 1
	_update_label()

	
	if total_items > 0 and items_collected >= total_items:
		all_items_collected.emit()


# Updates the label text
func _update_label():
	var label = get_node_or_null(label_path)
	if label:
		label.text = "Items: %d / %d" % [items_collected, total_items]
