extends Node2D


@export var MAX_HEALTH : float
var health


func _ready():
	health = MAX_HEALTH



func damage(attack):
	health -= attack
	
	if health <= 0:
		get_parent().queue_free()
