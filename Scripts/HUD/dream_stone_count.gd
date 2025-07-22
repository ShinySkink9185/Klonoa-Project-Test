extends Label

# TODO: Fix number positioning in 2D Mode, and
# add the Dream Stone icon. Don't worry about
# Maximum Counter right now; we'll add that later

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")

func _physics_process(_delta):
	text = str(stage_manager.dreamStones)
