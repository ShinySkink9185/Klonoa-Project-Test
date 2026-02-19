extends Node2D

# Label for text.
@onready var textLabel = $CanvasLayer/Text
@onready var animation = $AnimationPlayer

# Timer before next letter. Default is 5 frames.
var letterTimer := 0.0
var currentDialogue: String = ""
var confirmOption = false
var dialogueList := []
var justStarted = true

# testing function
func _init():
	defineDialogue("Testing 1!")
	defineDialogue("Testing 2!")

func _physics_process(delta):
	# Keep refreshing until the first bit of dialogue appears.
	if not currentDialogue and justStarted == true and animation.current_animation == "Idle":
		if dialogueList:
			currentDialogue = dialogueList[0].dialogue
			justStarted = false
		return
	
	if currentDialogue.length() > 0:
		if letterTimer <= 0:
			# Prints the first letter into box
			textLabel.text += currentDialogue.left(1)
			letterTimer = (1.0/60.0) * 2.0
			# Erases first letter of dialogue
			currentDialogue = currentDialogue.erase(0)
		else:
			letterTimer -= delta
	else:
		confirmOption = true
	
	# Advance the textbox, or delete it.
	if confirmOption == true and Input.is_action_just_pressed("jump"):
		confirmOption = false
		# Remove the last used object.
		dialogueList.remove_at(0)
		# If that's all the dialogue, remove the textbox.
		if not dialogueList:
			queue_free()
		else:
			currentDialogue = dialogueList[0].dialogue
		
			# Get the text currently in the box to disappear.
			if dialogueList[0].refreshBox == true:
				textLabel.text = ""

# Defines a new Speaker
func defineSpeaker(speaker: String, sound: String, image: String, coords: Vector2 = Vector2(0, 0)):
	pass

# Adds a dialogueEntry class that stores all the info of a single piece of dialogue
class dialogueEntry:
	# Our info
	var dialogue: String = ""
	var refreshBox: bool = true
	
	# Parameterized constructor
	func _init(setDialogue: String = "", setRefreshBox: bool = true):
		dialogue = setDialogue
		refreshBox = setRefreshBox

# Adds new dialogue to the queue using the class
func defineDialogue(setDialogue: String, setRefreshBox: bool = true):
	# Instantiate a class
	var dialogue = dialogueEntry.new(setDialogue, setRefreshBox)
	# Then, insert that object into our array!
	dialogueList.append(dialogue);

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Initial":
		animation.play("Idle")
