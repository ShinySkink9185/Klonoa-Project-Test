extends Label

@export var hudHealthID: int

# TODO: Fix number positioning in 2D Mode, and
# add the Dream Stone icon and maximum counter.

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")

func _physics_process(_delta):
	text = str(stage_manager.dreamStones)
