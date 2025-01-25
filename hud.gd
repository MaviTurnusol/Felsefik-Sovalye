extends Control

var healthComp
var berserkPoint
# Called when the node enters the scene tree for the first time.
func _ready():
	healthComp = UnlimitedRulebook.player.get_node("HealthComp")
	UnlimitedRulebook.hud = self
	healthComp.healthChanged.connect(_on_health_changed)
	berserkPoint = healthComp.berserkiumHealthValue/5
	$CanvasLayer/HPBar/nuts.size.x = berserkPoint * 0.64
	$CanvasLayer/Pause/HSlider.value = UnlimitedRulebook.volume
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.form == 1:
			$CanvasLayer/HPBar/sane.color = Color(0.608, 0, 0)
		else:
			$CanvasLayer/HPBar/sane.color = Color(1, 1, 1)
	if Input.is_action_just_pressed("escape"):
		if !get_tree().paused:
			get_tree().paused = true
			$CanvasLayer/Pause.visible = true
		else:
			get_tree().paused = false
			$CanvasLayer/Pause.visible = false
	UnlimitedRulebook.volume = $CanvasLayer/Pause/HSlider.value
	pass

func _on_health_changed(oldVal, newVal):
	$CanvasLayer/HPBar/sane.size.x = newVal * 0.64
	$CanvasLayer/HPBar/nuts.size.x = berserkPoint * 0.64
	if newVal < oldVal:
		var postwink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		var rottwink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		var colortwink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		var delta = (oldVal - newVal) * 0.64
		var fallRect = ColorRect.new()
		fallRect.color = $CanvasLayer/HPBar/sane.color
		fallRect.size = Vector2(delta, 8)
		fallRect.position = Vector2(-delta/2, -4)
		var marker = Marker2D.new()
		marker.position = Vector2(oldVal * 0.64 - delta/2, 4)
		$CanvasLayer.add_child(marker)
		marker.add_child(fallRect)
		
		postwink.tween_property(fallRect, "position", Vector2(fallRect.position.x, fallRect.position.y + 32), 1)
		rottwink.tween_property(marker, "rotation_degrees", randf_range(-15, 15)*6, 1)
		colortwink.tween_property(fallRect, "color", Color.TRANSPARENT, 1)
		colortwink.tween_callback(fallRect.queue_free)
	pass


func _on_pause_pressed():
	if !get_tree().paused:
		get_tree().paused = true
		$CanvasLayer/Pause.visible = true
	else:
		get_tree().paused = false
		$CanvasLayer/Pause.visible = false


func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
	pass # Replace with function body.


func _on_engi_toggled(toggled_on):
	if toggled_on:
		UnlimitedRulebook.globalEngineer = true
	else:
		UnlimitedRulebook.globalEngineer = false
	pass # Replace with function body.

func glitch():
	$sfx.volume_db = UnlimitedRulebook.volume
	$sfx.play()
	$CanvasLayer/glitcher.material.set_shader_parameter("shake_rate", 1)
	$CanvasLayer/glitcher.visible = true
	await get_tree().create_timer(0.4).timeout
	$CanvasLayer/glitcher.material.set_shader_parameter("shake_rate", 0.1)
	
func reverseGlitch():
	$sfx.volume_db = UnlimitedRulebook.volume
	$sfx.play()
	$CanvasLayer/glitcher.material.set_shader_parameter("shake_rate", 1)
	await get_tree().create_timer(0.4).timeout
	$CanvasLayer/glitcher.visible = false
