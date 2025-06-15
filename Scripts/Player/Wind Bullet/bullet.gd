extends CharacterBody2D

@onready var mainBullet = get_parent()
@onready var sprite = $Sprite2D

var SPEED = 252
var DECELERATION = 28

var time = 0

# TODO: The drawback phase. Should follow Klonoa.

func _physics_process(delta):
	# Save the player's current position for the drawback
	var playerPosition = mainBullet.playerPosition
	# Sprite flipping depending on the Wind Bullet's direction.
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
	time += delta
	if time <= 0.167:
		# Check the main Bullet's direction so we know which way we're shooting
		if mainBullet.direction < 0:
			velocity.x = -SPEED
		else:
			velocity.x = SPEED
		SPEED -= DECELERATION
	else:
		# TODO: Have the bullet travel back to Klonoa.
		# Can probably be done by gathering the Player and Bullet's global_positions, then
		# changing the Bullet's direction accordingly.
		# When the bullet gets close enough to Klonoa,
		# then make it disappear.
		# ...oh, and give the bullet a hitbox, too!
		print(playerPosition)
		pass
	
	move_and_slide()
