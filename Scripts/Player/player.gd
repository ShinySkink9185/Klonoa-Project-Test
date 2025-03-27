extends CharacterBody2D
class_name Player
signal hit


@export var SPEED = 90.000
@export var FLOATING_SPEED = 30.000
@export var JUMP_VELOCITY = -240.0
const FLOAT_VELOCITY = 60.000

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

var floatingTimer = 0
var floating = false
var hasFloated = false

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
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("moveLeft", "moveRight")
	if direction:
		if floating == true:
			velocity.x = direction * FLOATING_SPEED
		else:
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
# TODO: Actually get him hurt instead of this demo.
func _on_hit():
	velocity.y = JUMP_VELOCITY
