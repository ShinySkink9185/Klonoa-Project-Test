extends Area2D
class_name DreamStone

var stage_manager = load("res://Scripts/Stage Manager/stage_manager.gd")
var collected = false
var checkFree1 = false
var checkFree2 = false

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer

@export var value: int = 1

# Called when the player hits the collectible.
# TODO: Replace this with an area instead of a body.
func _on_body_entered(body):
	if collected == false and body is Player:
		collected = true
		stage_manager.getDreamStones(value)
		animation.play("Collected")
		$Sounds/Collected.play()

# When the sound's finished, check 1 is complete.
func _on_collected_sound_finished():
	checkFree1 = true

# When the animation's finished, check 2 is complete and the Stone disappears.
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Collected":
		sprite.visible = false
		checkFree2 = true

# Both checks? Then the stone's deleted.
func _physics_process(_delta):
	if checkFree1 == true && checkFree2 == true:
		queue_free()
