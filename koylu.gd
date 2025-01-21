extends CharacterBody2D


var speed = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
enum States { SWORDE, CHASE, BALL, IMPALE, AURA, DEAD, ENTER}  
var state: States = States.BALL : set = enterState
func _ready():
	$donek/HitBoxComp.father = self
	$HealthComp.father = self
	await get_tree().create_timer(0.5).timeout
	state = States.IMPALE
func enterState(value):
	if value == state:
		return
	if state == States.BALL:
		$donek/AnimatedSprite2D.rotation_degrees = 0
	if value == States.IMPALE:
		impale()
		$impaleTimer.start()
	if value == States.AURA:
		var aura = load("res://koylu_aura.tscn").instantiate()
		if UnlimitedRulebook.player:
			if UnlimitedRulebook.player.global_position.x < global_position.x:
				goToPlaces("right")
				velocity.x = -100
			else:
				goToPlaces("left")
				
				velocity.x = 100
		add_child(aura)
	if value == States.BALL:
		#var twink = get_tree().create_tween()
		#twink.tween_property(self, "velocity", global_position.direction_to(UnlimitedRulebook.player.global_position).normalized() * 600, 2)
		$stateChangeTimer.wait_time = randf_range(10, 20)
		$stateChangeTimer.start()
	if value == States.CHASE:
		$stateChangeTimer.wait_time = randf_range(10, 20)
		$stateChangeTimer.start()
	state = value
func _physics_process(delta):
	turn()
	if state == States.CHASE:
		velocity.x = lerp(velocity.x, sign(UnlimitedRulebook.player.global_position.x-global_position.x) * speed, 0.01)
		if not is_on_floor():
			velocity.y += 1.4 * delta * gravity
		move_and_slide()
	elif state == States.BALL:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.get_normal())
		var product = sqrt(velocity.x*velocity.x+velocity.y*velocity.y)
		$donek/AnimatedSprite2D.rotation_degrees += product * 3 * delta
		velocity.x = lerp(velocity.x, sign(UnlimitedRulebook.player.global_position.x-global_position.x) * speed * 3, 0.01)
		velocity.y = lerp(velocity.y, sign(UnlimitedRulebook.player.global_position.y-global_position.y) * speed * 3, 0.01)
	elif state == States.IMPALE:
		velocity.x = 0
		if not is_on_floor():
			velocity.y += 1.4 * delta * gravity
		pass
	elif state == States.SWORDE:
		swording()
		move_and_slide()
	elif state == States.AURA:
		move_and_slide()
		await get_tree().create_timer(4).timeout
		velocity.x = 0
		randomState()
func impale():
	var randNum = randi_range(-100, 100)
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x < global_position.x:
			goToPlaces("right")
		else:
			goToPlaces("left")
	for i in 10:
		var pillar = load("res://koylu_pillar.tscn").instantiate()
		pillar.global_position = clamp(Vector2(i*60+60+randNum, 335), Vector2(0, 335), Vector2(625, 335))
		get_tree().root.call_deferred("add_child", pillar)
func goToPlaces(place: String):
	match place:
		"right":
			var twink = get_tree().create_tween()
			twink.tween_property(self, "global_position", Vector2(500, 180), 0.5)
		"middle":
			var twink = get_tree().create_tween()
			twink.tween_property(self, "global_position", Vector2(320, 180), 0.5)
		"left":
			var twink = get_tree().create_tween()
			twink.tween_property(self, "global_position", Vector2(100, 180), 0.5)

func swording():
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x < global_position.x:
			goToPlaces("right")
		else:
			goToPlaces("left")
	await get_tree().create_timer(0.5).timeout
	$swordAnimator.play("bladeSwing")
	await get_tree().create_timer(4.2).timeout
	#randomState()

func turn():
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x < global_position.x:
			$donek.scale.x = 1
		else:
			$donek.scale.x = -1

func knockback(attacker):
	if state == States.CHASE:
		velocity = attacker.global_position.direction_to(global_position).normalized()*200
	if state == States.BALL:
		velocity = attacker.global_position.direction_to(global_position).normalized()*600
		velocity.y -= 400
		speed = 300

func launch():
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x < global_position.x:
			velocity.x = -900
		else:
			velocity.x = 900
	velocity.y = -900


func _on_impale_timer_timeout():
	if randi()%3 == 0:
		randomState()
	if state == States.IMPALE:
		impale()
		$impaleTimer.start()
	pass # Replace with function body.

func randomState():
	var rando = randi_range(0, 4)
	match rando:
		0:
			state = States.AURA
		1:
			state = States.BALL
		2:
			state = States.CHASE
		3:
			state = States.AURA
		4:
			state = States.SWORDE


func _on_state_change_timer_timeout():
	randomState()
	pass # Replace with function body.
