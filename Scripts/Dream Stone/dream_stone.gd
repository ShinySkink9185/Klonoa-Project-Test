extends Area2D
class_name DreamStone

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")
var collected = false

@onready var sprite = $Sprite2D

# Called when the player hits the collectible.
func _on_body_entered(_body):
	# TODO: Add collecting animations
	if collected == false:
		collected = true
		stage_manager.getDreamStones(1)
		sprite.visible = false
		$Sounds/Collected.play()

# When the sound's finished, delete the Dream Stone.
# If we deleted it in the above function, the sound would immediately
# get interrupted.
func _on_collected_sound_finished():
	queue_free()
