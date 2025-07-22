extends CharacterBody2D

@onready var mainBullet = get_parent()
@onready var sprite = $Sprite2D

const SPEED = 252
const DECELERATION = 28

var time = 0
var slowdownX = false
var slowdownY = false

func _physics_process(delta):
	# Save the player's current position for the drawback
	var playerPosition = mainBullet.playerPosition
	
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
		var travelSpeedX = 240
		var travelSpeedY = 240
		
		# Slow down the bullet if it gets close to Klonoa
		if global_position.x > playerPosition.x && global_position.x - playerPosition.x <= 20 || playerPosition.x > global_position.x && playerPosition.x - global_position.x <= 20:
			slowdownX = true
		if global_position.y > playerPosition.y && global_position.y - playerPosition.y <= 20 || playerPosition.y > global_position.y && playerPosition.y - global_position.y <= 20:
			slowdownY = true
		
		if slowdownX == true:
			travelSpeedX = 60
		if slowdownY == true:
			travelSpeedY = 60
		
		# Travel back to Klonoa.
		# This uses hacky stuff to make sure the bullet doesn't spiral out of control
		# whenever it's too close to Klonoa.
		if playerPosition.x > global_position.x && playerPosition.x - global_position.x >= 0.01:
			velocity.x = travelSpeedX
		elif global_position.x - playerPosition.x >= 0.01:
			velocity.x = -travelSpeedX
		
		if playerPosition.y - 16 > global_position.y && playerPosition.y - global_position.y >= 0.01:
			velocity.y = travelSpeedY
		elif global_position.y - playerPosition.y >= 0.01:
			velocity.y = -travelSpeedY
	else:
		queue_free()
	
	move_and_slide()
