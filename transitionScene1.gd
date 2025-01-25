extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var dial = load("res://startDial.dialogue")
	var dialogue_line = await dial.get_next_dialogue_line("start")
	DialogueManager.show_example_dialogue_balloon(dial, "start")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
