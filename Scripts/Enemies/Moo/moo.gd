extends Enemy

@export var HOVERBOARD = false

@onready var rayCast = $GroundRayCast

var justTurned = false

func _physics_process(delta):
	
	# Check if it's defeated.
	if defeated == true:
		# Spawn an explosion and nullify the enemy.
		var pop = popScene.instantiate()
		owner.add_child(pop)
		pop.global_transform = global_transform
		queue_free()
	
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
			rayCast.position.x = 3
		elif direction < 0:
			sprite.flip_h = true
			rayCast.position.x = -3
	
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
	elif animation.current_animation == "Look":
		DAMAGING = true
		velocity.x = 0
	else:
		DAMAGING = true
		velocity.x = SPEED * direction
	
	# Standard animation.
	if inflated == true or thrown == true or kicked == true:
		animation.play("Inflated")
	elif animation.current_animation != "Look":
		animation.play("Walk")
		
	# Turnarounds.
	if not inflated and not thrown and not kicked:
		if is_on_wall() and justTurned == false:
			direction = -direction
			justTurned = true
		elif rayCast.is_colliding() == false and is_on_floor() and justTurned == false:
			animation.play("Look")
	
	# Wind Bullet hit detection
	# I would've done this in Enemy but for some reason _physics_process
	# doesn't wanna work in the enemy script, only in this script!!! Yayy
	if windBulletHit == true && GRABBABLE == true and thrown == false:
		inflated = true
		windBulletHit = false
	
	# Moving depending on if the enemy has been thrown or not.
	if thrown == true or kicked == true:
		PROJECTILE = true
		$Hitbox.add_to_group("projectileHitbox")
		if move_and_collide(velocity * delta) != null:
			defeated = true
	else:
		move_and_slide()
	
	# Hacky look check because the raycast position doesn't update in time.
	# TODO: fix the Moo having a seizure against a wall
	if justTurned == true and not is_on_wall():
		justTurned = false

# This turns our lil' guy around if he's done looking.
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Look":
		direction = -direction
		animation.play("Walk")
		justTurned = true
