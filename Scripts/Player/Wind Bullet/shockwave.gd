extends CharacterBody2D

@onready var mainBullet = get_parent()
@onready var sprite = $Sprite2D

# When the shockwave spawns...
func _ready():
	# Flip the shockwave's sprite depending on its direction.
	if mainBullet.direction > 0:
		sprite.flip_h = false
	elif mainBullet.direction < 0:
		sprite.flip_h = true

# When the shockwave animation finishes, delete it.
func _on_animation_player_animation_finished(_anim_name):
	queue_free()
	pass # Replace with function body.
