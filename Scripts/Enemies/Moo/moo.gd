extends CharacterBody2D
class_name Enemy

@export var SPEED = 30.000
@export var HOVERBOARD = false

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

func _physics_process(delta):
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Set initial direction.
	var direction = "left"
	
	# Handle direction facing.
	if direction == "right":
		sprite.flip_h = false
	elif direction == "left":
		sprite.flip_h = true
	
	# Handle movement.
	if direction == "right":
		velocity.x = SPEED
	elif direction == "left":
		velocity.x = -SPEED
	
	# Animation.
	animation.play("Walk")
	
	move_and_slide()
