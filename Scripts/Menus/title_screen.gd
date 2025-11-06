extends Node2D

@onready var animation = $AnimationPlayer

# Placeholder function for going into the game
func _on_animation_player_animation_finished(_anim_name):
	get_tree().change_scene_to_file("res://Scenes/Levels/Green Hill Zone 1 GG/green_hill_zone_1_gg.tscn")
