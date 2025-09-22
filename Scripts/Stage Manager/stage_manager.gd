extends Node
class_name StageManager

static var dreamStones = 0
static var health = 3

# Maybe some of this stuff can be moved to the individual player?
# You know... for multiplayer purposes.

var game_manager = load("res://Scripts/Game Manager/game_manager.gd")

@export var MUSIC: AudioStream
@export var LOOP_POINT: float = 0

func _ready():
	$MusicPlayer.stream = MUSIC
	$MusicPlayer.play()

static func getDreamStones(amount):
	dreamStones += amount

static func adjustHealth(amount):
	health += amount

func _on_music_player_finished():
	$MusicPlayer.seek(LOOP_POINT)
	$MusicPlayer.play()

# Restart the scene when Klonoa dies
func _physics_process(_delta):
	if health <= 0:
		## get_tree().reload_current_scene()
		## health = 3
		## dreamStones = 0
		## game_manager.lives -= 1
		pass
		# Get rid of the reload temporarily for something in the player.
