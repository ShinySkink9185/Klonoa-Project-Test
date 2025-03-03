extends Node
class_name StageManager

static var dreamStones = 0
static var health = 3

static func getDreamStones(amount):
	dreamStones += amount
	print(dreamStones)
