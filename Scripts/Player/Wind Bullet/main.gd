extends Node2D
class_name WindBullet

# Direction of the Wind Bullet. This is set by the player's direction.
var direction = 0
# Player node and info.
var player
var playerPosition
# The Bullet's position for the Trail to follow.
var bulletPosition

var checkFree1
var checkFree2

func _ready():
	# Set the Bullet's direction based on the player
	if player.sprite.flip_h == true:
		direction = -1
	else:
		direction = 1
	# Play SFX
	$Sounds/FireBullet.play()

func _physics_process(_delta):
	playerPosition = player.global_position
	if get_node_or_null("Bullet") != null:
		bulletPosition = $Bullet.global_position
	else:
		bulletPosition = null
	
	if get_node_or_null("Shockwave") == null and get_node_or_null("Bullet") == null and get_node_or_null("Trail") == null:
		checkFree1 = true
	
	if checkFree1 == true and checkFree2 == true:
		queue_free()

func _on_fire_bullet_sound_finished():
	checkFree2 = true
	
func _on_hitbox_area_entered(area):
	if area.is_in_group("damageHitbox"):
		area.get_path()
		print(area.get_path())
