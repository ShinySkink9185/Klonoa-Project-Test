extends AnimatableBody2D

# TODO: check if Klonoa falls on the Spring, then do its action.
# On its bounceup, launch Klonoa depending on if he is pressing the Jump button.
# Speaking of which, prevent him from jumping normally on a Spring.

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var hitboxShape = $Hitbox/CollisionShape2D

var initiated = false

func _on_hitbox_body_entered(body):
	# Don't have the spring collide with itself.
	if initiated == false and body is Player:
		initiated = true
		animation.play("Spring")

func _physics_process(_delta):
	# Make whatever is on it change y positions according to wherever the animation is.
	if $Hitbox.get_overlapping_bodies():
		for body in $Hitbox.get_overlapping_bodies():
			body.global_position.y = hitboxShape.global_position.y
			# Prevent Klonoa from jumping.
			if body is Player:
				body.preventJumping = true

func _on_animation_finished(_anim_name):
	# Check doesn't matter since it always goes back to Idle
	initiated = false
	animation.play("Idle")

func _on_spring_propel():
	if $Hitbox.get_overlapping_bodies():
		for body in $Hitbox.get_overlapping_bodies():
			if body is Player && Input.is_action_pressed("jump"):
				body.velocity.y = -457.333
			else:
				body.velocity.y = -287
