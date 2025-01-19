extends Control

var number = 300
var duration = 1

@onready var labl = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	labl.text = str(round(number))
	labl.pivot_offset = labl.size/2
	number = clamp(number, 0, 1000)
	duration = number/333
	var color = Color(1.0, 1.0 - number/1000.0, 0.0)
	var color2 = Color(1.0 - number/1000.0, 0.0, 0.0)
	labl.scale = Vector2(number/500, number/500)
	labl.add_theme_color_override("font_color", color)
	labl.add_theme_color_override("font_outline_color", color2)
	var colortwink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	colortwink.tween_property($Label, "theme_override_colors/font_color", Color.TRANSPARENT, duration)
	var colortwink2 = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	colortwink2.tween_property($Label, "theme_override_colors/font_outline_color", Color.TRANSPARENT, duration)
	await get_tree().create_timer(duration-0.3).timeout
	var scaletwink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	scaletwink.tween_property($Label, "scale", Vector2(0.5, 0.5), 0.3)
	await get_tree().create_timer(0.3).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass
