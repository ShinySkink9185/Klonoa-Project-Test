extends CharacterBody2D

@onready var mainBullet = get_parent()
@onready var sprite = $Sprite2D

var delayTimer = 0

var history = []

func _ready():
	sprite.visible = false

# TODO: Trail seems a little choppy; maybe improve this later?
func _physics_process(delta):
	# Initial timer
	if delayTimer >= 0.05:
		sprite.visible = true
	delayTimer += delta
	# Calculate the Bullet's position and when it was in that position...
	# ...then if the delay is big enough and there's no other time that
	# fulfills that, the Trail goes to the Bullet!
	if mainBullet.bulletPosition != null:
		var bulletPosition = mainBullet.bulletPosition
		history.append({"time": delayTimer, "position": mainBullet.bulletPosition})
		var savedPosition = null
		var count = 0
		for historyEntry in history:
			if delayTimer - historyEntry["time"] >= 0.05:
				savedPosition = historyEntry["position"]
				count += 1
			else:
				while count > 1:
					history.pop_front()
					count -= 1
				break
		if savedPosition != null:
			global_position = savedPosition
	else:
		queue_free()
