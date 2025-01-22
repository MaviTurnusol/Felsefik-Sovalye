extends Node2D


@export var MAX_HEALTH : float
var health : set = set_health
var father
var berserkiumHealthValue

signal healthChanged(oldVal, newVal)

func set_health(value):
	if value >= MAX_HEALTH:
		value = MAX_HEALTH
	if value <= 0:
		value = 0
		if father:
			if father.has_method("death"):
				father.death()
	if UnlimitedRulebook.player:
		if father == UnlimitedRulebook.player:
			if is_instance_valid(father):
				if father.form == 0:
					if value <= berserkiumHealthValue/5:
						father.form = 1
						value = berserkiumHealthValue/5
						healthChanged.emit(health, value)
						health = value
						berserkiumHealthValue = -10
						UnlimitedRulebook.hud.berserkPoint = -10
	if value != health:
		healthChanged.emit(health, value)
		health = value

func _ready():
	health = MAX_HEALTH
	berserkiumHealthValue = MAX_HEALTH

func damage(attack):
	health -= attack
	print(health)
