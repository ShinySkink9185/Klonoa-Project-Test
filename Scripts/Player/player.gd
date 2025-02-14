extends CharacterBody2D


const SPEED = 90.000
const JUMP_VELOCITY = -240.0

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("moveLeft", "moveRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle direction facing.
	if direction > 0:
		sprite.flip_h = false
	else: if direction < 0:
		sprite.flip_h = true
	
	# Animations!
	
	if is_on_floor():
		if direction == 0:
			if animation.current_animation == "Fall":
				animation.play("Land")
			else: if animation.current_animation != "Land":
				animation.play("Stand")
		else:
			animation.play("Walk")
	else: if velocity.y < 0:
		animation.play("Jump")
	else:
		if animation.current_animation_position >= 0.4:
			animation.play("Fall")
			animation.seek(0.2667)
		else:
			animation.play("Fall")
	
	move_and_slide()
	
