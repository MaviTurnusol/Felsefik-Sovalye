extends Node2D

var rising = false
var stopRising = false
@onready var sword = $cutter/swordBody
func _ready():
	await get_tree().create_timer(1.1).timeout
	$cutter/swordBody/HarmBoxComp.monitoring = true
func _physics_process(delta):
	if rising:
		sword.position.y = lerp(sword.position.y, 850.0, 0.1)
	if stopRising:
		sword.position.y = lerp(sword.position.y, 800.0, 0.1)
	
func _on_animator_animation_finished(anim_name):
	rising = true
	await get_tree().create_timer(1).timeout
	rising = false
	stopRising = true
	await get_tree().create_timer(0.5).timeout
	var twink = get_tree().create_tween()
	twink.tween_property(sword.get_node("sprite"), "modulate", Color.TRANSPARENT, 0.5)
	await get_tree().create_timer(0.5).timeout
	queue_free()
