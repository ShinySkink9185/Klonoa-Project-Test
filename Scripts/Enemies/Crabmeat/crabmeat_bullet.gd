extends CharacterBody2D

const DAMAGING = true

func _physics_process(delta):
	# Gravity.
	velocity += get_gravity() * delta
	
	move_and_slide()
