extends Label

# TODO: Maximum counter

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")

func _physics_process(_delta):
	text = str(stage_manager.dreamStones)
