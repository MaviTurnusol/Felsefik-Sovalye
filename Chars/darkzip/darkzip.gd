extends CharacterBody2D

enum States { ENTER, RUN, ATTACK, FLY, DEAD, SOMUR}
var state: States = States.ENTER
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 100

@onready var sprite = $Body/sprite
func _ready():
	$Body/HitBoxComp.father = self
	$Body/HealthComp.father = self
	$Body/HarmBoxComp.atk = 50
	await get_tree().create_timer(0.8).timeout
	state = States.RUN
	sprite.play("jumping")
func _physics_process(delta):
	if not is_on_floor():
		if state == States.SOMUR || state == States.DEAD:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta * 4
	if state == States.ENTER:
		velocity.x = lerp(velocity.x, sign(320-global_position.x) * speed, 0.05)
	elif state == States.RUN:
		if is_on_wall():
			velocity.x = sign(get_slide_collision(0).get_normal().x) * speed
		if $Body/HealthComp.health <= 1000:
			state = States.SOMUR
			velocity.y -= 600
	elif state == States.SOMUR:
		if is_on_floor():
			rotation_degrees = 0.0
		else:
			rotation_degrees += delta * randf_range(-25, 25) * 10
		$Body/HitBoxComp/col1.set_deferred("disabled", true)
		$Body/HitBoxComp/col11.set_deferred("disabled", true)
		$Body/HitBoxComp/col2.set_deferred("disabled", false)
		$Body/HarmBoxComp/col1.set_deferred("disabled", true)
		$Body/HarmBoxComp/col2.set_deferred("disabled", false)
		sprite.play("somurgen")
		velocity.x = lerp(velocity.x, sign(UnlimitedRulebook.player.global_position.x-global_position.x) * speed, 0.01)
	elif state == States.DEAD:
		var scaletwink = get_tree().create_tween()
		var colortwink = get_tree().create_tween()
		var rottwink = get_tree().create_tween()
		scaletwink.tween_property(self, "scale", Vector2(8, 8), 6)
		colortwink.tween_property(self, "modulate", Color.BLACK, 4)
		rottwink.tween_property(self, "rotation_degrees", randf_range(-256, 256), 6)
		scaletwink.tween_callback(queue_free)
		move_and_slide()
	if velocity.x > 0:
		$Body.scale.x = 1
	elif velocity.x < 0:
		$Body.scale.x = -1
	move_and_slide()

func flying():
	await get_tree().create_timer(0.01).timeout
	create_ghost()
func _on_sprite_animation_looped():
	if sprite.animation == "jumping":
		if state == States.RUN:
			if randi()%4 == 0:
				sprite.play("inflate")
	pass # Replace with function body.


func _on_sprite_animation_finished():
	if sprite.animation == "inflate":
		velocity.x = sign(UnlimitedRulebook.player.global_position.x - global_position.x)*speed
		state == States.FLY
		sprite.play("deflate")
		var twink = get_tree().create_tween()
		$collision1.set_deferred("disabled", true)
		create_ghost()
		$ghosto.start()
		twink.tween_property(self, "global_position", Vector2(UnlimitedRulebook.player.global_position.x, UnlimitedRulebook.player.global_position.y - 200), 0.5)
		await get_tree().create_timer(0.5).timeout
		velocity.x = sign(UnlimitedRulebook.player.global_position.x - global_position.x)*speed
		$collision1.set_deferred("disabled", false)
		$ghosto.stop()
	if sprite.animation == "deflate":
		await get_tree().create_timer(0.5).timeout
		state == States.RUN
		sprite.play("jumping")

func create_ghost():
	var animSprite = AnimatedSprite2D.new()
	animSprite.sprite_frames = sprite.sprite_frames
	animSprite.play(sprite.animation)
	animSprite.frame = sprite.frame
	animSprite.pause()
	animSprite.global_position = sprite.global_position
	animSprite.scale *= 2
	animSprite.flip_h = sprite.flip_h
	animSprite.modulate = Color.BLACK
	get_tree().root.add_child(animSprite)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(animSprite, "modulate", Color.TRANSPARENT, 0.33)
	await get_tree().create_timer(0.33).timeout
	animSprite.queue_free()


func _on_ghosto_timeout():
	create_ghost()
	if state == States.FLY:
		$ghosto.start()

func death():
	$collision1.set_deferred("disabled", true)
	$Body/HarmBoxComp.monitoring = false
	$Body/HitBoxComp.monitoring = false
	state = States.DEAD
	velocity.y -= 300
	velocity.x = randf_range(-400, 400)
	sprite.pause()

func knockback(attacker):
	velocity.x = -sign(attacker.global_position.x - global_position.x)*200
