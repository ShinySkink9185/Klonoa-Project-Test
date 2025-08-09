extends Node
class_name StageManager

static var dreamStones = 0
static var health = 3

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
