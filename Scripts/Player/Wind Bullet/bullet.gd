extends CharacterBody2D

@onready var mainBullet = get_parent()
@onready var sprite = $Sprite2D

const SPEED = 252
const DECELERATION = 28

var time = 0

func _physics_process(delta):
	# Save the player's current position for the drawback
	var playerPosition = mainBullet.playerPosition
	playerPosition.y -= 16
	
	# Sprite flipping depending on the Wind Bullet's direction.
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
	# Would've done this in func _ready():, but for some reason that always
	# detected mainBullet.direction as fulfilling the "else" condition
	# So we're going to put it here instead
	if time == 0:
		if mainBullet.direction < 0:
			velocity.x = -SPEED
		else:
			velocity.x = SPEED
	
	time += delta
	if time <= 0.167:
		# Check the main Bullet's direction so we know which way we need to decelerate
		if mainBullet.direction < 0:
			velocity.x += DECELERATION
		else:
			velocity.x -= DECELERATION
	elif time <= 0.35:
		velocity.x = (playerPosition.x - global_position.x)*15
		velocity.y = (playerPosition.y - global_position.y)*15
	else:
		queue_free()
	
	move_and_slide()
