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
	
	# TODO: Figure out how to make animations loop for falling
	# Animations!
	if is_on_floor():
		if direction == 0:
			animation.play("Stand")
		else:
			animation.play("Walk")
	else: if velocity.y < 0:
		animation.play("Jump")
	else:
		animation.play("Fall")
	
	move_and_slide()

# Animation loops
func _on_animation_player_animation_finished(animation):
	if animation.get_current_animation() == "Fall":
		animation.play("Fall")
		animation.seek(0.2667)
