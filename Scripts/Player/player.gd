extends CharacterBody2D
class_name Player

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")

# These may change depending on the state Klonoa is in (surfboard, e.t.c.)
@export var SPEED = 90.000
@export var FLOATING_SPEED = 30.000
@export var JUMP_VELOCITY = -240.0
@export var KICKJUMP_VELOCITY = -300.0
const FLOAT_VELOCITY = 60.000

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var windBulletScene = load("res://Scenes/Player/Wind Bullet/wind_bullet.tscn")

# All of our timers and checks
var floatingTimer = 0
var floating = false
var hasFloated = false
var hittingDamage = false
var isHurt = false
var hurtTimer = 0
var isDead = false
var deadTimer = 0
var playedDeathFadeout = false
var bufferTimer = 0
var firing = false
var fireDelayTimer = 0
var carrying = false
var carryTarget = null
var throwTimer = 0
var kicking = false
var kickDelayTimer = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and floating == false:
		velocity += get_gravity() * delta
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("moveLeft", "moveRight")
	# Don't make direction more than 1, or else some smart guy'll abuse stick physics.
	if direction > 1:
		direction = 1
	elif direction < -1:
		direction = -1
	
	# Klonoa moves according to the direction.
	# TODO: maybe have a stick deadzone?
	if direction and isHurt == false and isDead == false and not (is_on_floor() && firing == true) and kicking == false:
		if floating == true:
			velocity.x = direction * FLOATING_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle direction facing.
	if direction > 0 and isHurt == false and isDead == false:
		sprite.flip_h = false
		$WindBulletSpawn.set_position(Vector2(12, -16))
	elif direction < 0 and isHurt == false and isDead == false:
		sprite.flip_h = true
		$WindBulletSpawn.set_position(Vector2(-12, -16))

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		# A regular jump.
		if is_on_floor():
			$Sounds/Jump.play()
			velocity.y = JUMP_VELOCITY
		# A kick-jump!
		elif carrying == true:
			carrying = false
			carryTarget.inflated = false
			carryTarget.kicked = true
			carryTarget = null
			kicking = true
	
	# Handle kick-jumping!
	if kicking == true:
		const KICKPREP_VELOCITY = 60
		# 4 stages: descending, stability, ascending, and the launch!
		if kickDelayTimer < 0.05:
			kickDelayTimer += delta
			velocity = Vector2(0, KICKPREP_VELOCITY)
		elif kickDelayTimer < 0.1333:
			kickDelayTimer += delta
			velocity = Vector2(0, 0)
		elif kickDelayTimer < 0.1833:
			kickDelayTimer += delta
			velocity = Vector2(0, -KICKPREP_VELOCITY)
		else:
			kicking = false
			kickDelayTimer = 0
			velocity.y = KICKJUMP_VELOCITY
			$Sounds/Voice/Wahoo.play()
			
	
	# Floating thinker.
	if velocity.y >= 0 and not is_on_floor() and hasFloated == false and Input.is_action_pressed("jump") and carrying == false and kicking == false:
		hasFloated = true
		floating = true
		$Sounds/Float.play()
	
	# Floating.
	if floating == true and Input.is_action_pressed("jump") and floatingTimer < 1.133 and not is_on_floor():
		# 3 stages: descending, stability, and ascending.
		if floatingTimer < 0.3:
			velocity.y = FLOAT_VELOCITY
		elif floatingTimer < 0.833:
			velocity.y = 0
		else:
			velocity.y = -FLOAT_VELOCITY
		floatingTimer += delta
	else:
		if floating == true:
			velocity.y = 0
		floating = false
		floatingTimer = 0
		$Sounds/Float.stop()
		
	# Firing Actions
	if Input.is_action_just_pressed("fire") and isHurt == false and kicking == false:
		# Throwing an Item
		if carrying == true:
			carrying = false
			carryTarget.inflated = false
			carryTarget.global_position.y += 22
			if sprite.flip_h == true:
				carryTarget.direction = -1
			else:
				carryTarget.direction = 1
			carryTarget.thrown = true
			carryTarget = null
			throwTimer = 0.3666
		# Firing the Wind Bullet
		elif firing == false:
			firing = true
			var windBullet = windBulletScene.instantiate()
			# Pass the player to the Wind Bullet
			# Self-note: use a method like this instead of getting a node's parent!
			windBullet.player = self
			owner.add_child(windBullet)
			windBullet.transform = $WindBulletSpawn.global_transform
		# Stopping floating
		if floating == true:
			velocity.y = 0
			floating = false
			floatingTimer = 0
			$Sounds/Float.stop()
	
	# Thinkers for firing and throwing timers
	if firing == true:
		if fireDelayTimer >= 0.3667:
			firing = false
		else:
			fireDelayTimer += delta
	else:
		fireDelayTimer = 0
	
	if throwTimer <= 0:
		throwTimer = 0
	else:
		throwTimer -= delta
	
	# Hit detection
	# Check if there is actually a hitbox colliding with Klonoa, if the hitbox
	# is marked as "can damage", and if it actually does damage.
	if $Hitbox.get_overlapping_areas():
		for area in $Hitbox.get_overlapping_areas():
			if area.is_in_group("damageHitbox") && area.get_parent().DAMAGING == true:
				hittingDamage = true
			else:
				hittingDamage = false
	else:
		hittingDamage = false
	
	# Hurt knockback
	if isHurt == true && hurtTimer < 0.2667:
		if sprite.flip_h == false:
			velocity.x = -60
		else:
			velocity.x = 60
		velocity.y = -60
		hurtTimer += delta
		floating = false
		floatingTimer = 0
	elif hurtTimer >= 0.2667:
		isHurt = false
		hurtTimer = 0
		hasFloated = false
		
	# Death knockback
	if isDead == true:
		floating = false
		floatingTimer = 0
		if deadTimer < 0.2667:
			velocity = Vector2(0, -60)
			deadTimer += delta
		elif deadTimer < 0.5333:
			velocity = Vector2(0, 60)
			deadTimer += delta
		else:
			var currentStage = get_tree().current_scene
			if currentStage.has_node("ScreenHandler") and playedDeathFadeout == false:
				var screenHandler = currentStage.get_node("ScreenHandler")
				screenHandler.play("Death Fadeout")
				playedDeathFadeout = true
			deadTimer += delta
		
	# Get him hurt on hit.
	if isHurt == false and isDead == false and bufferTimer <= 0 and hittingDamage == true:
		bufferTimer = 1
		stage_manager.adjustHealth(-1)
		if stage_manager.health <= 0:
			$Sounds/Voice/Death.play()
			isDead = true
		else:
			$Sounds/Voice/Hurt.play()
			isHurt = true
		
	# Buffer frames
	if bufferTimer > 0:
		var bufferTimerBlinkReference = bufferTimer
		# Find out what frame cycle we're on.
		while bufferTimerBlinkReference >= 0.0667:
			bufferTimerBlinkReference -= 0.0667
		if bufferTimerBlinkReference >= 0.0334:
			sprite.hide()
		else:
			sprite.show()
		bufferTimer -= delta
	else:
		sprite.show()
	
	# Animations!
	# Here, we define a carryCheck for animations so we don't have to check
	# for each individual animation on whether or not Klonoa is carrying
	# something.
	var carryCheck
	if carrying == true:
		carryCheck = " (Grab)"
	else:
		carryCheck = ""
	
	if isHurt == true or isDead == true:
		animation.play("Hurt")
	# TODO: Figure out how to make the below 2 animations be interrupted
	# by other animations
	elif kicking == true:
		animation.play("Kick-Jump")
	elif firing == true:
		animation.play("Fire")
	elif throwTimer != 0:
		animation.play("Throw")
	elif is_on_floor():
		hasFloated = false
		if direction == 0:
			if animation.current_animation == "Fall" or animation.current_animation == "Fall (Grab)":
				animation.play("Land")
			elif animation.current_animation != "Land":
				if Input.is_action_pressed("moveDown") == true and Input.is_action_pressed("moveUp") == false and carrying == false:
					animation.play("Walk (Front)")
				elif Input.is_action_pressed("moveUp") == true and Input.is_action_pressed("moveDown") == false and carrying == false:
					animation.play("Walk (Back)")
				elif animation.current_animation == "Walk (Front)" or animation.current_animation == "Stand (Front)":
					animation.play("Stand (Front)")
				elif animation.current_animation == "Walk (Back)" or animation.current_animation == "Stand (Back)":
					animation.play("Stand (Back)")
				else:
					animation.play("Stand" + carryCheck)
		else:
			animation.play("Walk" + carryCheck)
	elif floating == true:
		animation.play("Float")
	elif velocity.y < 0:
		animation.play("Jump" + carryCheck)
	else:
		if carrying == true and animation.current_animation_position >= 0.2666:
			animation.play("Fall (Grab)")
			animation.seek(0.1333)
		elif animation.current_animation_position >= 0.4:
			animation.play("Fall")
			animation.seek(0.2667)
		else:
			animation.play("Fall" + carryCheck)
	
	move_and_slide()

# Loop the Floating sound whenever it finishes
# Because of how this function works, it won't
# initiate when it's stopped. Thanks, Godot devs!
func _on_float_sound_finished():
	$Sounds/Float.play()
