extends Node2D

# Direction of the Wind Bullet. This is set by the player's direction.
var direction = 0
# Player node and info.
var player
var playerPosition

func _ready():
	# Set the Bullet's direction based on the player
	if player.sprite.flip_h == true:
		direction = -1
	else:
		direction = 1

func _physics_process(delta):
	playerPosition = player.global_position
	pass
