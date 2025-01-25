extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicBook.openMusic("boss2")
	MusicBook.deglitchSound()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fin_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Chars/finish_scene.tscn")
	pass # Replace with function body.
