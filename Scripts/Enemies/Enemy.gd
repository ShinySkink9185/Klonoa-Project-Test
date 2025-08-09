extends CharacterBody2D
class_name Enemy

@export var SPEED: float
@export var GRABBABLE = true
@export var RESPAWN = true

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
