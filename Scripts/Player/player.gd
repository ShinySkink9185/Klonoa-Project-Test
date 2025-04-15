extends CharacterBody2D
class_name Player
signal hit

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")

@export var SPEED = 90.000
@export var FLOATING_SPEED = 30.000
@export var JUMP_VELOCITY = -240.0
const FLOAT_VELOCITY = 60.000

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

var floatingTimer = 0
var floating = false
var hasFloated = false
var isHurt = false
var hurtTimer = 0
var bufferTimer = 0
var firing = false
var fireDelayTimer = 0
var grabbing = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and floating == false:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$Sounds/Jump.play()
		velocity.y = JUMP_VELOCITY
	
	# Floating thinker.
	if velocity.y >= 0 and not is_on_floor() and hasFloated == false and Input.is_action_pressed("jump"):
		hasFloated = true
		floating = true
	
	# Floating.
	if floating == true and Input.is_action_pressed("jump") and floatingTimer < 1.133 and not is_on_floor():
		if floatingTimer < 0.3:
			floatingTimer += delta
			velocity.y = FLOAT_VELOCITY
		else: if floatingTimer < 0.833:
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
		
	# Firing the Wind Bullet
	if Input.is_action_pressed("fire") and isHurt == false:
		firing = true
		if floating == true:
			velocity.y = 0
			hasFloated = true
			floating = false
			floatingTimer = 0
	
	if firing == true:
		if fireDelayTimer >= 0.3667:
			firing = false
		else:
			fireDelayTimer += delta
	else:
		fireDelayTimer = 0
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("moveLeft", "moveRight")
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
	else: if direction < 0 && isHurt == false:
		sprite.flip_h = true
	
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
	else: if hurtTimer >= 0.2667:
		isHurt = false
		hurtTimer = 0
		hasFloated = false
		
	# Buffer frames
	if bufferTimer > 0:
		var bufferTimerBlinkReference = bufferTimer
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
	if isHurt == true:
		animation.play("Hurt")
	elif firing == true:
		animation.play("Fire")
	elif is_on_floor():
		hasFloated = false
		if direction == 0:
			if animation.current_animation == "Fall":
				animation.play("Land")
			else: if animation.current_animation != "Land":
				if Input.is_action_pressed("moveDown") == true and Input.is_action_pressed("moveUp") == false:
					animation.play("Walk (Front)")
				else: if Input.is_action_pressed("moveUp") == true and Input.is_action_pressed("moveDown") == false:
					animation.play("Walk (Back)")
				else: if animation.current_animation == "Walk (Front)" or animation.current_animation == "Stand (Front)":
					animation.play("Stand (Front)")
				else: if animation.current_animation == "Walk (Back)" or animation.current_animation == "Stand (Back)":
					animation.play("Stand (Back)")
				else:
					animation.play("Stand")
		else:
			animation.play("Walk")
	else: if floating == true:
		animation.play("Float")
	else: if velocity.y < 0:
		animation.play("Jump")
	else:
		if animation.current_animation_position >= 0.4:
			animation.play("Fall")
			animation.seek(0.2667)
		else:
			animation.play("Fall")
	
	move_and_slide()

# Initialize a hit.
func _on_hitbox_area_entered(area):
	if area.is_in_group("damageHitbox"):
		hit.emit()

# Get him hurt on hit.
func _on_hit():
	if isHurt == false && bufferTimer <= 0:
		isHurt = true
		bufferTimer = 1
		stage_manager.adjustHealth(-1)
		$Sounds/Voice/Hurt.play()
