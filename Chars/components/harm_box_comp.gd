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
		area.damage(atk)
		if engineer:
			$CanvasLayer/engi.visible = true
			$CanvasLayer/engi.modulate = Color.WHITE
			var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
			twink.tween_property($CanvasLayer/engi, "modulate", Color.TRANSPARENT, 0.2)
			twink.tween_property($CanvasLayer/engi, "visible", false, 0)
			

func activate(duration):
	monitoring = true
	while duration > 0:
		await Engine.get_main_loop().process_frame
		duration -= 1
		print("sex", duration)
	monitoring = false

func deactivate(duration):
	monitoring = false
	await get_tree().create_timer(duration).timeout
	monitoring = true
