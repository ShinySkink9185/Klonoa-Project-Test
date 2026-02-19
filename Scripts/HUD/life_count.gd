extends Label

var game_manager = load("res://Scripts/Game Manager/game_manager.gd")

func _physics_process(_delta):
	text = str(game_manager.lives)
