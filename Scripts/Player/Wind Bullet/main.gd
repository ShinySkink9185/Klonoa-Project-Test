extends Node2D
class_name WindBullet

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
	# Play SFX
	$Sounds/FireBullet.play()

func _physics_process(_delta):
	playerPosition = player.global_position
	pass
