extends CharacterBody2D

func _ready():
	$enterexit.play("ente")
	await get_tree().create_timer(4).timeout
	$enterexit.play_backwards("ente")
	await get_tree().create_timer(1).timeout
	queue_free()
