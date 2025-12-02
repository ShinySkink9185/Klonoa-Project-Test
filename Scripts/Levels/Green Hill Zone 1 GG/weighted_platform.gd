extends Path2D

@onready var hitbox = $AnimatableBody2D/Hitbox
@onready var animation = $AnimationPlayer

var activated = false
var initialAnimationLock = false
var finalAnimationLock = false

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
	if activated == true && initialAnimationLock == false:
		animation.play("Default", -1, 1)
		finalAnimationLock = false
	elif finalAnimationLock == false:
		animation.play("Default", -1, -0.5, true)
		initialAnimationLock = false

# Lock animation so it doesn't loop.
func _on_animation_player_animation_finished(_anim_name):
	if activated == true:
		initialAnimationLock = true
	else:
		finalAnimationLock = true
