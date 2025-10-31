extends Control
@onready var task_label = $PanelContainer/VBoxContainer/TaskLabel
@onready var progress_bar = $PanelContainer/VBoxContainer/ProgressBar
@onready var count_label = $PanelContainer/VBoxContainer/CountLabel

func update_ui(items_collected: int, total_items: int):
	var percent = float(items_collected) / float(total_items) * 100.0
	progress_bar.value = percent
	count_label.text = "Items: %d /%d" % [items_collected, total_items]
	
	
