extends Enemy

@export var HOVERBOARD = false

func _physics_process(delta):
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Set initial direction.
	var direction = -1
	
	# Handle direction facing.
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	# Handle movement, both when inflated and as a normal enemy.
	if inflated == true:
		DAMAGING = false
		velocity.x = 0
		velocity.y = 0
		global_position.x = windBulletFirer.global_position.x
		global_position.y = windBulletFirer.global_position.y - 24
		windBulletFirer.carrying = true
		windBulletFirer.carryTarget = get_node(".")
	else:
		DAMAGING = true
		velocity.x = SPEED * direction
	
	# Animation.
	if inflated == true:
		animation.play("Inflated")
	else:
		animation.play("Walk")
	
	# Wind Bullet hit detection
	# I would've done this in Enemy but for some reason _physics_process
	# doesn't wanna work in the enemy script, only in this script!!! Yayy
	if windBulletHit == true && GRABBABLE == true:
		inflated = true
		windBulletHit = false
	
	move_and_slide()
