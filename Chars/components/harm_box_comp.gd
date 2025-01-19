extends Area2D

@export var alwaysActive = false
@export var engineer = false
var atk = 0

func _ready():
	if !alwaysActive:
		monitoring = false
	area_entered.connect(harm)

func harm(area):
	if area.has_method("damage"):
		area.damage(atk, self)
		if engineer:
			$CanvasLayer/engi.visible = true
			$CanvasLayer/engi.modulate = Color.WHITE
			var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
			twink.tween_property($CanvasLayer/engi, "modulate", Color.TRANSPARENT, 0.2)
			twink.tween_property($CanvasLayer/engi, "visible", false, 0)
	if area.has_method("intel"):
		area.intel(self)

func activate(duration):
	monitoring = true
	await get_tree().create_timer(duration).timeout
	monitoring = false

func deactivate(duration):
	monitoring = false
	await get_tree().create_timer(duration).timeout
	monitoring = true
