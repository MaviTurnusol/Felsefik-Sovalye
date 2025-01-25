extends CharacterBody2D

@export var speed = 50
var direction = -1

func _ready():
	var twink = get_tree().create_tween()
	twink.tween_property(self, "speed", 400, 0.5)
	var twink2 = get_tree().create_tween()
	twink2.tween_property(self, "modulate", Color.WHITE, 0.5)
	await get_tree().create_timer(8).timeout
	queue_free()

func _physics_process(delta):
	var target = Vector2(cos(rotation), sin(rotation)).normalized()*speed
	position -= target * delta
	print(rotation_degrees)
