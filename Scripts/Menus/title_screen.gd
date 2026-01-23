extends Node2D

@onready var animation = $AnimationPlayer
@onready var animPosition = animation.current_animation_position

func _physics_process(_delta):
	# This is to skip all the logos if you mash the button.
	# Useful stuff!
	define_animation_skip(0.5, 3.5)
	define_animation_skip(5.5, 7.5)
	define_animation_skip(12, 13.8)
	
# Just to make it easier on ourselves to skip stuff.
# If played between startingPosition and endingPosition,
# this skips straight to the endingPosition.
func define_animation_skip(startingPosition: float, endingPosition: float):
	animPosition = animation.current_animation_position
	if animPosition >= startingPosition && animPosition <= endingPosition && Input.is_action_just_pressed("jump"):
		animation.play_section(&"", endingPosition)

# Placeholder function for going into the game
func _on_animation_player_animation_finished(_anim_name):
	get_tree().change_scene_to_file("res://Scenes/Levels/Green Hill Zone 1 GG/green_hill_zone_1_gg.tscn")
