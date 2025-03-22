extends Node2D

@export var hudHealthID: int

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")

func _physics_process(delta):
	
	if (stage_manager.health - 1) < hudHealthID:
		hide()
	else:
		show()
