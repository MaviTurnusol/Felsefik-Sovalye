extends Node2D

@onready var sprite = $anima
@export var gradientTexture : GradientTexture2D
@onready var redGradient = preload("res://redgradient.tres")
@onready var blueGradient = preload("res://bluegradient.tres")
@export var visibility : float = 0.0

var changingColor = false
# Called when the node enters the scene tree for the first time.
func _ready():
	print(blueGradient.colors)
	gradientTexture = preload("res://red2d.tres")
	var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	twink.tween_property(self, "visibility", 0.6, 0.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.material.set_shader_parameter("intensity_factor", visibility)
	sprite.material.set_shader_parameter("TONE_MAPPING", gradientTexture)
	#rotation_degrees += delta * 100
	_handle_hurtbox()
	pass

func _handle_hurtbox():
	match sprite.animation:
		"nightmonster":
			if sprite.frame == 7:
				$hitsocks/air.activate(2)

func apppear():
	var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	twink.tween_property(self, "visibility", 0.6, 0.5)

func changeColor(color: String):
	match color:
		"red":
			#changingColor = true
			var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
			var red = PackedColorArray([Color(0, 0, 0, 0), Color(0, 0, 0, 0), Color(0, 0, 0, 1), Color(0.2235, 0, 0, 1), Color(0, 0, 0, 1), Color(0, 0, 0, 0), Color(0, 0, 0, 0)])
			twink.tween_property(gradientTexture, "gradient:colors", red, 0.25)
			#await get_tree().create_timer(0.5).timeout
			#changingColor = false
		"blue":
			#changingColor = true
			var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
			var blue = PackedColorArray([Color(0, 0, 0, 0), Color(0, 0, 0, 0), Color(0, 0, 0, 1), Color(0.046, 0, 0.3475, 1), Color(0, 0, 0, 1), Color(0, 0, 0, 0), Color(0, 0, 0, 0)])
			twink.tween_property(gradientTexture, "gradient:colors", blue, 0.25)
			#await get_tree().create_timer(0.5).timeout
			#changingColor = false
