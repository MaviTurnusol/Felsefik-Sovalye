extends Node2D


@export var MAX_HEALTH : float
var health : set = set_health
var father

signal healthChanged(oldVal, newVal)

func set_health(value):
	if value >= MAX_HEALTH:
		value = MAX_HEALTH
	if value <= 0:
		value = 0
		if father:
			if father.has_method("death"):
				father.death()
	if value != health:
		healthChanged.emit(health, value)
		health = value

func _ready():
	health = MAX_HEALTH

func damage(attack):
	health -= attack
	print(health)
