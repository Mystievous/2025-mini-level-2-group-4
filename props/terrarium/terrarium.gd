extends Node2D

signal completed

@onready var _leaves: Sprite2D = %Leaves
@onready var _bottle_cap: Sprite2D = %BottleCap
@onready var _doll: Sprite2D = %Doll
@onready var _hamster_wheel: Sprite2D = %HamsterWheel
@onready var _skull: Sprite2D = %Skull

var missing_items: int = 5:
	get():
		return missing_items
	set(value):
		missing_items = value
		if missing_items == 0:
			completed.emit()

func add_leaves():
	if _leaves.visible:
		return
	_leaves.visible = true
	missing_items -= 1

func add_bottle_cap():
	if _bottle_cap.visible:
		return
	_bottle_cap.visible = true
	missing_items -= 1
		
func add_doll():
	if _doll.visible:
		return
	_doll.visible = true
	missing_items -= 1
		
func add_hamster_wheel():
	if _hamster_wheel.visible:
		return
	_hamster_wheel.visible = true
	missing_items -= 1
		
func add_skull():
	if _skull.visible:
		return
	_skull.visible = true
	missing_items -= 1
