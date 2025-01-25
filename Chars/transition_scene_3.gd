extends Node2D


func _ready():
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://arena_3.tscn")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
