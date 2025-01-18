extends Node2D

@onready var darktar = preload("res://Chars/darktar/darktar.tscn")

var wave = 1
var alive_enemy = 0

func _ready():
	start_wave()



func start_wave():
	var instance = darktar.instantiate()
	instance.get_child(-1).dead.connect(on_enemy_death)
	alive_enemy += 1
	instance.global_position = Vector2(randi_range(15,625),316)

func on_enemy_death():
	if alive_enemy == 0:
		await get_tree().create_timer(3).timeout
		start_wave()
	else:
		alive_enemy -= 1
