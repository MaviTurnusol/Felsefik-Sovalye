extends CharacterBody2D


const SPEED = 300.0
var direction = -1

func _ready():
	await get_tree().create_timer(8).timeout
	queue_free()

func _physics_process(delta):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction > 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	move_and_slide()
