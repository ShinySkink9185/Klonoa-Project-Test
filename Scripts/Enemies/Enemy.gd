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
