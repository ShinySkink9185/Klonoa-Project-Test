extends Path2D

@onready var hitbox = $AnimatableBody2D/Hitbox
@onready var animation = $AnimationPlayer

var activated = false
var direction = "up"

func _physics_process(_delta):
	# It should initially do false.
	activated = false

	# If the player is on it, it should be activated.
	# REMEMBER: The player only goes through Collision Layer 2 on the hitbox.
	if hitbox.get_overlapping_bodies():
		for body in hitbox.get_overlapping_bodies():
			if body is Player:
				activated = true
	
	# Play animations.
	if activated == true && direction == "up":
		animation.play("Default", -1, 1)
		direction = "down"
	elif activated == false && direction == "down":
		animation.play("Default", -1, -0.5, true)
		direction = "up"
