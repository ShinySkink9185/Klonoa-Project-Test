extends CharacterBody2D
class_name Player

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")

# These may change depending on the state Klonoa is in (surfboard, e.t.c.)
@export var SPEED = 90.000
@export var FLOATING_SPEED = 30.000
@export var JUMP_VELOCITY = -240.0
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
var bufferTimer = 0
var firing = false
var fireDelayTimer = 0
var carrying = false
var carryTarget = null

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and floating == false:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$Sounds/Jump.play()
		velocity.y = JUMP_VELOCITY
	
	# Floating thinker.
	if velocity.y >= 0 and not is_on_floor() and hasFloated == false and Input.is_action_pressed("jump") and carrying == false:
		hasFloated = true
		floating = true
		$Sounds/Float.play()
	
	# Floating.
	if floating == true and Input.is_action_pressed("jump") and floatingTimer < 1.133 and not is_on_floor():
		# 3 stages: descending, stability, and ascending.
		if floatingTimer < 0.3:
			floatingTimer += delta
			velocity.y = FLOAT_VELOCITY
		elif floatingTimer < 0.833:
			floatingTimer += delta
			velocity.y = 0
		else:
			floatingTimer += delta
			velocity.y = -FLOAT_VELOCITY
	else:
		if floating == true:
			velocity.y = 0
		floating = false
		floatingTimer = 0
		$Sounds/Float.stop()
		
	# Firing Actions
	if Input.is_action_just_pressed("fire") and isHurt == false:
		if carrying == true:
			carrying = false
			carryTarget.inflated = false
			carryTarget = null
		# Firing the Wind Bullet
		elif firing == false:
			firing = true
			var windBullet = windBulletScene.instantiate()
			# Pass the player to the Wind Bullet
			# Self-note: use a method like this instead of getting a node's parent!
			windBullet.player = self
			owner.add_child(windBullet)
			windBullet.transform = $WindBulletSpawn.global_transform
		if floating == true:
			velocity.y = 0
			floating = false
			floatingTimer = 0
			$Sounds/Float.stop()
	
	if firing == true:
		if fireDelayTimer >= 0.3667:
			firing = false
		else:
			fireDelayTimer += delta
	else:
		fireDelayTimer = 0
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("moveLeft", "moveRight")
	# Don't make direction more than 1, or else some smart guy'll abuse stick physics.
	if direction > 1:
		direction = 1
	elif direction < -1:
		direction = -1
	
	if direction && isHurt == false && not (is_on_floor() && firing == true):
		if floating == true:
			velocity.x = direction * FLOATING_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle direction facing.
	if direction > 0 && isHurt == false:
		sprite.flip_h = false
		$WindBulletSpawn.set_position(Vector2(12, -16))
	elif direction < 0 && isHurt == false:
		sprite.flip_h = true
		$WindBulletSpawn.set_position(Vector2(-12, -16))
	
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
		
	# Get him hurt on hit.
	if isHurt == false and bufferTimer <= 0 and hittingDamage == true:
		isHurt = true
		bufferTimer = 1
		stage_manager.adjustHealth(-1)
		$Sounds/Voice/Hurt.play()
		
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
	
	if isHurt == true:
		animation.play("Hurt")
	# TODO: Figure out how to make the below animation be interrupted
	# by other animations
	elif firing == true:
		animation.play("Fire")
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

# Initialize a hit.
func _on_hitbox_area_entered(area):
	var target = get_node(area.get_parent().get_path())
	if area.is_in_group("damageHitbox") && target.DAMAGING == true:
		hittingDamage = true

# De-initialize a hit if the damaging factor has exited.
func _on_hitbox_area_exited(area):
	var target = get_node(area.get_parent().get_path())
	if area.is_in_group("damageHitbox") && target.DAMAGING == true:
		hittingDamage = false

# Loop the Floating sound whenever it finishes
# Because of how this function works, it won't
# initiate when it's stopped. Thanks, Godot devs!
func _on_float_sound_finished():
	$Sounds/Float.play()
