extends Node

# Does nothing for now, but we'll keep this since
# we may need it for saving permanent game data eventually

static var lives = 3

func _ready():
	get_tree().change_scene_to_file("res://Scenes/Levels/Green Hill Zone 1 GG/green_hill_zone_1_gg.tscn")
