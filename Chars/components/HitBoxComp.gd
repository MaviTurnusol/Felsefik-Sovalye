extends Area2D

@export var health_comp : Node2D



func damage(attack):
	if health_comp:
		health_comp.damage(attack)
