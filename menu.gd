extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://arena_1.tscn")
	pass # Replace with function body.


func _on_koylu_pressed():
	get_tree().change_scene_to_file("res://arena_2.tscn")


func _on_exit_pressed():
	$TextureRect.visible = true
	await get_tree().create_timer(2).timeout
	$TextureRect.visible = false
	pass # Replace with function body.
