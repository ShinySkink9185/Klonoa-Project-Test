extends Area2D

# Called when the player hits the collectible.
func _on_body_entered(body):
	# TODO: Add collecting animations, store value in HUD
	print("Dream Stone +1")
	queue_free()
