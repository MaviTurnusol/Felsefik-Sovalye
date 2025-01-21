extends CharacterBody2D

func _ready():
	await get_tree().create_timer(2).timeout
	$animator.play("esira")
	await get_tree().create_timer(0.5).timeout
	queue_free()
