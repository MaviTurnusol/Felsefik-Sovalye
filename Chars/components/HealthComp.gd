extends Node2D

signal dead

@export var MAX_HEALTH : float
var health


func _ready():
	health = MAX_HEALTH



func damage(attack):
	health -= attack
	print(health)
	if health <= 0:
		dead.emit()
		get_parent().queue_free()
