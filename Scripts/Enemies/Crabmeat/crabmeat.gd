extends Enemy

@onready var bulletScene = load("res://Scenes/Enemies/Crabmeat/crabmeat_bullet.tscn")

var walkingTimer = 400.0/60.0
var bulletTime1 = 0
var bulletTime2 = 0

# We need to set these to true so it doesn't fire initially.
var hasFired1 = true
var hasFired2 = true

@onready var hitbox = $Hitbox

# Set the pop scene
func _ready():
	popScene = load("res://Scenes/Effects/pop_(sonic_1_gg).tscn")

func _physics_process(delta):
	
	# Spawn an explosion and nullify the enemy if defeated.
	if defeated == true:
		var pop = popScene.instantiate()
		owner.add_child(pop)
		pop.global_position = Vector2(global_position.x, global_position.y - 22)
		queue_free()
	
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Movement.
	if walkingTimer >= 0:
		velocity.x = SPEED * direction
		walkingTimer -= delta
		animation.play("Walk")
	else:
		velocity.x = 0
		animation.play("Fire")
	
	# Firing bullets.
	bulletTime1 -= delta
	bulletTime2 -= delta
	
	if bulletTime1 <= 0 and hasFired1 == false:
		var bullet = bulletScene.instantiate()
		owner.add_child(bullet)
		bullet.velocity = Vector2(-60, -240)
		bullet.global_position = $BulletSpawn1.global_position
		hasFired1 = true
	
	if bulletTime2 <= 0 and hasFired2 == false:
		var bullet = bulletScene.instantiate()
		owner.add_child(bullet)
		bullet.velocity = Vector2(60, -240)
		bullet.global_position = $BulletSpawn2.global_position
		hasFired2 = true
	
	move_and_slide()

func fireBullet():
	bulletTime1 = randf_range(0, 4.0/60.0)
	bulletTime2 = randf_range(0, 4.0/60.0)
	hasFired1 = false
	hasFired2 = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fire":
		walkingTimer = 400.0/60.0
		direction = -direction
		
# Destroy it!
func _on_hitbox_area_entered(area):
	if area.is_in_group("projectileHitbox"):
		defeated = true
		area.get_parent().defeated = true
