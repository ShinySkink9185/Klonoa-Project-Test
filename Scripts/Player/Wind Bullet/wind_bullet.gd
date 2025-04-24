extends Node2D

# TODO: Everything. This includes spawning all three components upon spawn,
# making the bullet move and come back to Klonoa, making the trail follow the
# bullet, and making the bullet detect enemies and grab them.

func _on_animation_player_animation_finished(anim_name):
	$Shockwave.queue_free()
	pass # Replace with function body.
