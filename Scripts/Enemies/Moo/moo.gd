extends Enemy

@export var HOVERBOARD = false

func _physics_process(delta):
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle direction facing.
	if inflated == true:
		sprite.flip_h = false
	elif thrown == true or kicked == true:
		sprite.flip_h = true
	else:
		if direction > 0:
			sprite.flip_h = false
		elif direction < 0:
			sprite.flip_h = true
	
	# Handle movement, both when inflated and as a normal enemy.
	if inflated == true:
		DAMAGING = false
		velocity = Vector2(0,0)
		global_position = Vector2(windBulletFirer.global_position.x, windBulletFirer.global_position.y - 24)
		windBulletFirer.carrying = true
		windBulletFirer.carryTarget = get_node(".")
	elif thrown == true:
		velocity = Vector2(THROWSPEED * direction, 0)
	elif kicked == true:
		velocity = Vector2(0, THROWSPEED)
	else:
		DAMAGING = true
		velocity.x = SPEED * direction
	
	# Animation.
	if inflated == true or thrown == true or kicked == true:
		animation.play("Inflated")
	else:
		animation.play("Walk")
	
	# Wind Bullet hit detection
	# I would've done this in Enemy but for some reason _physics_process
	# doesn't wanna work in the enemy script, only in this script!!! Yayy
	if windBulletHit == true && GRABBABLE == true and thrown == false:
		inflated = true
		windBulletHit = false
	
	# Moving depending on if the enemy has been thrown or not.
	if thrown == true or kicked == true:
		if move_and_collide(velocity * delta) != null:
			var pop = popScene.instantiate()
			owner.add_child(pop)
			pop.global_transform = global_transform
			queue_free()
	else:
		move_and_slide()
