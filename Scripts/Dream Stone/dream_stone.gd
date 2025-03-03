extends Area2D
class_name DreamStone

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")

# Called when the player hits the collectible.
func _on_body_entered(body):
	# TODO: Add collecting animations, store value in HUD
	stage_manager.getDreamStones(1)
	queue_free()
