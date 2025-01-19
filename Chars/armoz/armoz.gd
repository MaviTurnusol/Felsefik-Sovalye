extends CharacterBody2D

var fuckindead = false
var speed = 300
var state
var target : CharacterBody2D = null : set = set_target
enum States {ENTER, ORBIT, ATTACK, DEAD}
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func set_target(value):
	if target != value:
		if $targetCd.is_stopped():
			target = value
			$targetCd.start()
func _ready():
	$HitBoxComp.father = self
	$HealthComp.father = self
	$HarmBoxComp.atk = 25
	state = States.ENTER
	await get_tree().create_timer(0.6).timeout
	state = States.ORBIT
func _physics_process(delta):
	var twink = get_tree().create_tween()
	if state == States.ENTER:
		velocity.x = lerp(velocity.x, sign(320-global_position.x) * speed, 0.05)
		velocity.y = lerp(velocity.y, sign(200-global_position.y) * speed, 0.05)
	elif state == States.ORBIT:
		orbiting()
	elif state == States.ATTACK:
		attacking()
	elif state == States.DEAD:
		velocity.y += gravity * delta * 1.4
		var scaletwink = get_tree().create_tween()
		var colortwink = get_tree().create_tween()
		scaletwink.tween_property(self, "scale", Vector2(8, 8), 6)
		colortwink.tween_property(self, "modulate", Color.BLACK, 4)
		rotation_degrees += delta * randf_range(-256, 256)
		scaletwink.tween_callback(queue_free)
	move_and_slide()

func orbiting():
	if is_instance_valid(target):
		if global_position.distance_to(target.global_position) > 160:
			velocity.x = lerp(velocity.x, sign(target.global_position.x-global_position.x) * speed, 0.05)
			velocity.y = lerp(velocity.y, sign(target.global_position.y-global_position.y) * speed, 0.05)
		else:
			velocity.x = lerp(velocity.x, -sign(target.global_position.x-global_position.x) * speed, 0.05)
			velocity.y = lerp(velocity.y, -sign(target.global_position.y-global_position.y) * speed, 0.05)
	elif UnlimitedRulebook.player:
		target = UnlimitedRulebook.player
		await get_tree().create_timer(3).timeout
		if state != States.DEAD:
			if randi()%3 == 0:
				state = States.ATTACK

func attacking():
	if UnlimitedRulebook.player:
		if global_position.y<250:
			velocity.x = lerp(velocity.x, sign(UnlimitedRulebook.player.global_position.x-global_position.x) * speed, 0.01)
			velocity.y = lerp(velocity.y, sign(UnlimitedRulebook.player.global_position.y-global_position.y) * speed, 0.01)
		else:
			velocity.x = lerp(velocity.x, sign(UnlimitedRulebook.player.global_position.x-global_position.x) * speed, 0.01)
			velocity.y = lerp(velocity.y, -sign(UnlimitedRulebook.player.global_position.y-global_position.y) * speed, 0.01)

func _on_vision_body_entered(body):
	if body.is_in_group("armoz"):
		if body.target != self && body != self:
			if body.state:
				if body.state != States.DEAD:
					target = body
					print(body.target, self)
	pass # Replace with function body.


func _on_target_cd_timeout():
	if randi()%3 == 0:
		if UnlimitedRulebook.player:
			target = UnlimitedRulebook.player
			await get_tree().create_timer(3).timeout
			if state != States.DEAD:
				if randi()%3 == 0:
					state = States.ATTACK
	pass # Replace with function body.

func death():
	$CollisionShape2D.set_deferred("disabled", true)
	$HarmBoxComp.monitoring = false
	$HitBoxComp.monitoring = false
	fuckindead = true
	velocity.y -= 500
	velocity.x = randf_range(-400, 400)
	state = States.DEAD
