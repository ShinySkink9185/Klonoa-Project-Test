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
	
	# Handle movement.
	velocity.x = SPEED * direction
	
	# Animation.
	animation.play("Walk")
	
	move_and_slide()
