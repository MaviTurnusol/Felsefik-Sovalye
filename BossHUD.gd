extends CanvasLayer

@onready var healthComp = $"../HealthComp"
# Called when the node enters the scene tree for the first time.
func _ready():
	healthComp.healthChanged.connect(_on_health_changed)
	$HPBar.size.x = healthComp.MAX_HEALTH*5/640
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HPBar.position.x = 0
	
	pass

func _on_health_changed(oldVal, newVal):
	$HPBar.size.x = healthComp.health*5/640
	if newVal < oldVal:
		var postwink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		var rottwink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		var colortwink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		var delta = (oldVal - newVal) * healthComp.MAX_HEALTH*2/640
		var fallRect = ColorRect.new()
		fallRect.size = Vector2(delta, 8)
		fallRect.position = Vector2(-delta/2, -4)
		var marker = Marker2D.new()
		marker.position = Vector2(oldVal * healthComp.MAX_HEALTH*2/640 - delta/2, 352)
		add_child(marker)
		marker.add_child(fallRect)
		postwink.tween_property(fallRect, "position", Vector2(fallRect.position.x, fallRect.position.y - 32), 1)
		rottwink.tween_property(marker, "rotation_degrees", randf_range(-15, 15)*6, 1)
		colortwink.tween_property(fallRect, "color", Color.TRANSPARENT, 1)
		colortwink.tween_callback(fallRect.queue_free)
	pass
