extends Enemy

@export var HOVERBOARD = false

@onready var rayCast = $GroundRayCast

var justTurned = false

func _physics_process(delta):
	# Run the subclass's _physics_process
	super._physics_process(delta)
	
	# Add gravity.
	if not is_on_floor() and not inflated and not thrown and not kicked:
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
	
	# Handle movement as a normal enemy.
	if not inflated and not thrown and not kicked:
		if animation.current_animation == "Look":
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

# Destroy it if a projectile hits it!
func _on_hitbox_area_entered(area):
	if area.is_in_group("projectileHitbox"):
		defeated = true
		area.get_parent().defeated = true

# Enable processing only once the enemy is on screen.
func _on_visible_on_screen_notifier_2d_screen_entered():
	process_mode = Node.PROCESS_MODE_INHERIT # This is Inherit mode.
