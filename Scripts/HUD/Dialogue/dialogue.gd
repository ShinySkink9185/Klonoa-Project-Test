extends Node2D

# Labels for text.
@onready var textLabel = $CanvasLayer/Text
@onready var animation = $AnimationPlayer
@onready var speakerLabel1 = $CanvasLayer/Speaker1
@onready var speakerLabel2 = $CanvasLayer/Speaker2
@onready var speakerLabel3 = $CanvasLayer/Speaker3

# Sound banks.
@onready var soundBankTalk = $AudioStreamTalk
@onready var soundBankExtra = $AudioStreamExtra
@onready var soundBankMusic = $AudioStreamMusic

# Timer before next letter. Default is 5 frames.
var letterTimer := 0.0
var currentDialogue: String = ""
var confirmOption = false
var dialogueList := []
var justStarted = true

# These can be changed depending on Speaker settings.
# TODO: change this to the Sonic Battle dialogue
var talkSound = "res://Assets/Sounds/HUD/Dialogue/TextRegular.wav"

const TEXTSPEED = (1.0/60.0) * 2.0

func _init():
	# Define all of our speakers for text
	defineSpeaker("Klonoa", "res://Assets/Images/HUD/Dialogue/DialogueBox.png", Vector2(0, 0), )
	# testing dialogue, remove later
	defineDialogue("Testing 1!", true, "Klonoa")
	defineDialogue("Testing 2 without the speaker")
	defineDialogue("Oh hey there it is", false, "Klonoa")

func _physics_process(delta):
	# Keep refreshing until the first bit of dialogue appears.
	if not currentDialogue and justStarted == true and animation.current_animation == "Idle":
		if dialogueList:
			drawNewDialogue()
			justStarted = false
		return
	
	if currentDialogue.length() > 0:
		if letterTimer <= 0:
			# Prints the first letter into box
			textLabel.text += currentDialogue.left(1)
			letterTimer = TEXTSPEED
			# Erases first letter of stored dialogue
			currentDialogue = currentDialogue.erase(0)
			# Play the dialogue sound
			soundBankTalk.play()
		else:
			letterTimer -= delta
	elif justStarted == false:
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
			
			# Get the text currently in the box to disappear.
			if dialogueList[0].refreshBox == true:
				textLabel.text = ""
				speakerLabel1.visible = false
				speakerLabel2.visible = false
				speakerLabel3.visible = false
			
			drawNewDialogue()
					
		
			

# This function handles starting a new piece of dialogue.
func drawNewDialogue():
	# Set the current dialogue.
	currentDialogue = dialogueList[0].dialogue
	
	# Insert initial text if there is a speaker.
	if dialogueList[0].speaker != "":
		# Add a new line if this is a continuation.
		if dialogueList[0].refreshBox == false:
			textLabel.text += "\n"
		textLabel.text += "    :"
		
		# Show the Speaker images depending on line count.
		match textLabel.get_line_count():
			3:
				speakerLabel3.visible = true
			2:
				speakerLabel2.visible = true
			1:
				speakerLabel1.visible = true
		
		# Add delay
		letterTimer = TEXTSPEED

# Defines a new Speaker
# TODO: find Sonic Battle dialogue sound and replace the sound with that
func defineSpeaker(speaker: String, image: String = "res://Assets/Images/HUD/Dialogue/DialogueBox.png", coords: Vector2 = Vector2(0, 0), sound: String = "res://Assets/Sounds/HUD/Dialogue/TextRegular.wav"):
	pass

# Adds a dialogueEntry class that stores all the info of a single piece of dialogue
class dialogueEntry:
	# Our info
	var dialogue: String = ""
	var refreshBox: bool = true
	var speaker: String = ""
	
	# Parameterized constructor
	func _init(setDialogue: String = "", setRefreshBox: bool = true, setSpeaker: String = ""):
		dialogue = setDialogue
		refreshBox = setRefreshBox
		speaker = setSpeaker

# Adds new dialogue to the queue using the class
func defineDialogue(setDialogue: String, setRefreshBox: bool = true, setSpeaker: String = ""):
	# Instantiate a class
	var dialogue = dialogueEntry.new(setDialogue, setRefreshBox, setSpeaker)
	# Then, insert that object into our array!
	dialogueList.append(dialogue);

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Initial":
		animation.play("Idle")
