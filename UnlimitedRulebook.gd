extends Node

var player
var hud
var wave = 0
const SAVE_PATH_1 = "user://save1.json"
var infoLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	pass

func frameFreeze(timeScale, duration):
	if player.form != 1:
		Engine.time_scale = timeScale
		await get_tree().create_timer(timeScale * duration).timeout
		OS.delay_msec(10)
		Engine.time_scale = 1.0
	else:
		Engine.time_scale = timeScale
		await get_tree().create_timer(timeScale * duration).timeout
		OS.delay_msec(10)
		Engine.time_scale = 1.1
