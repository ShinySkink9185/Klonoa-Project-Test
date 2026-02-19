extends Node2D

@onready var initialMessage = $"CanvasLayer/Initial Message"
var messagePossibilities = ["a bystander to the tragedy.", "time doesn't wait for you.", "a dreamer through and through.", "a different type of convergence.", "the only thing weirder than your sister.", "other worlds just don't measure up.", "a hero, his adventure, and his ears.", "i'm out of ideas for openings."]


func _ready():
	var textOption = randi_range(0, messagePossibilities.size() - 1)
	initialMessage.text = messagePossibilities[textOption];
