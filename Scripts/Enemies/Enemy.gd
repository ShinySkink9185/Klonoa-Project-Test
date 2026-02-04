extends CharacterBody2D
class_name Enemy

var windBulletHit = false
var windBulletFirer

@export var SPEED: float
@export var THROWSPEED: float
@export var direction = -1
@export var GRABBABLE = true
@export var RESPAWN = true
@export var DAMAGING = true
# TODO: Having "DAMAGING" as a parameter when we already have a damagingHitbox
# group is a little redundant. Can't we just... remove damagingHitbox?
@export var PROJECTILE = false

var inflated = false
var thrown = false
var kicked = false
var defeated = false

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var popScene = load("res://Scenes/Effects/pop.tscn")

# TODO: Use super class for enemies and port basic info here.
func _physics_process(delta):
	# Wind Bullet hit detection
	if windBulletHit == true && GRABBABLE == true and thrown == false:
		inflated = true
		windBulletHit = false
		
	# Handle movement, both when inflated and as a normal enemy.
	if inflated == true:
		DAMAGING = false
		velocity = Vector2(0,0)
		global_position = Vector2(windBulletFirer.global_position.x, windBulletFirer.global_position.y - 24)
		windBulletFirer.carrying = true
		windBulletFirer.carryTarget = get_node(".")
	elif thrown == true:
		velocity = Vector2(THROWSPEED * direction, 0)
	elif kicked == true:
		velocity = Vector2(0, THROWSPEED)
		
	# Check if it's defeated.
	if defeated == true:
		# Spawn an explosion and nullify the enemy.
		var pop = popScene.instantiate()
		owner.add_child(pop)
		pop.global_transform = global_transform
		queue_free()
