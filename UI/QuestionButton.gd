extends TextureButton

@onready var instructions = $"../InstructionUIContainer"

func _ready():
	if instructions:
		instructions.visible = false
		instructions.modulate.a = 0.0  # start invisible
	else:
		push_warning("⚠️ InstructionUIContainer not found! Check node path.")

	connect("pressed", _on_pressed)


func _on_pressed():
	if not instructions:
		push_warning("⚠️ InstructionUIContainer not found — cannot toggle.")
		return

	# If currently hidden → fade in
	if not instructions.visible:
		instructions.visible = true
		fade_in(instructions)
	else:
		fade_out(instructions)


# Fade in smoothly
func fade_in(node: Control):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.25)  # fade in 0.25s


# Fade out smoothly, then hide at end
func fade_out(node: Control):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, 0.25)  # fade out 0.25s
	tween.finished.connect(func(): node.visible = false)


# Detect outside clicks to close
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and instructions and instructions.visible:
		var mouse_pos = get_global_mouse_position()
		var clicked_instructions = instructions.get_global_rect().has_point(mouse_pos)
		var clicked_button = get_global_rect().has_point(mouse_pos)

		# Close when clicking outside both
		if not clicked_instructions and not clicked_button:
			fade_out(instructions)
			print("Clicked outside — instructions closed.")
