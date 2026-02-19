extends Node2D
# Label for text.
@onready var textLabel = $CanvasLayer/Text

# Timer before next letter. Default is 5 frames.
var letterTimer := 0.0
var currentDialogue: String = "This is something else, is it not?"
var confirmOption = false
var dialogueList := []
# TODO: make dialogue list have all the variables of dialogue block function

func _physics_process(delta):
	if currentDialogue.length() > 0:
		if letterTimer <= 0:
			# Prints the first letter into box
			textLabel.text += dialogueList[0].dialogue.left(1)
			letterTimer = (1.0/60.0) * 2.0
			# Erases first letter of dialogue
			currentDialogue = dialogueList[0].dialogue.erase(0)
		else:
			letterTimer -= delta
	else:
		confirmOption = true

# Defines a new Speaker
func defineSpeaker(speaker: String, sound: String, image: String, coords: Vector2 = Vector2(0, 0)):
	pass

# Adds a dialogueEntry class that stores all info of a single box
class dialogueEntry:
	# Our info
	var dialogue: String = ""
	var refreshBox: bool = false
	
	# Parameterized constructor
	func _init(setDialogue: String = "", setRefreshBox: bool = false):
		dialogue = setDialogue
		refreshBox = setRefreshBox

# Adds new dialogue to the queue using the class
func defineDialogue(setDialogue: String, setRefreshBox: bool = true):
	# Instantiate a class
	var dialogue = dialogueEntry.new(setDialogue, setRefreshBox)
	dialogueList.append(dialogue);

# Ends the dialogue block
func endDialogue():
	pass
