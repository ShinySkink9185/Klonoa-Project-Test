extends CharacterBody2D
class_name Enemy

var windBulletHit = false
var windBulletFirer

@export var SPEED: float
@export var GRABBABLE = true
@export var RESPAWN = true
@export var DAMAGING = true

var inflated = false

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
