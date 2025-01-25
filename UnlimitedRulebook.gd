extends Node

var player
var hud
var wave = 0
const SAVE_PATH_1 = "user://save1.json"
var infoLabel
var scroller
var globalEngineer = false
var volume = 0.0
var cam

signal changeScene
# Called when the node enters the scene tree for the first time.
func _ready():
	changeScene.connect(onChangeScene)
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		#get_tree().quit()
		pass
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

func onChangeScene(scene):
	get_tree().change_scene_to_file(scene)
