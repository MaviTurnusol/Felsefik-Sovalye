extends CharacterBody2D


var speed = 300.0
var grimmCharges = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
enum States { SWORDE, CHASE, BALL, IMPALE, AURA, DEAD, ENTER, GRIMM}  
var state: States = States.ENTER : set = enterState
func _ready():
	$donek/HitBoxComp.father = self
	$HealthComp.father = self
	await get_tree().create_timer(1.5).timeout
	state = States.CHASE
	$randomImpaler.wait_time = randf_range(1, 8)
	$randomImpaler.start()
func enterState(value):
	$stateChangeTimer.stop()
	if state == States.BALL:
		$donek/AnimatedSprite2D.rotation_degrees = 0
		await get_tree().create_timer(0.5).timeout
		$donek/AnimatedSprite2D.rotation_degrees = 0
	if state == States.GRIMM:
		$donek/AnimatedSprite2D.play("default")
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
		$stateChangeTimer.wait_time = 4
		$stateChangeTimer.start()
	if state == States.CHASE:
		$donek/Truck.visible = false
		$donek/harmer/trucke.set_deferred("disabled", true)
		$donek/HitBoxComp/trucke.set_deferred("disabled", true)
		$donek/AnimatedSprite2D.position.y = -33
	if value == States.BALL:
		#var twink = get_tree().create_tween()
		#twink.tween_property(self, "velocity", global_position.direction_to(UnlimitedRulebook.player.global_position).normalized() * 600, 2)
		$stateChangeTimer.wait_time = randf_range(5, 10)
		$stateChangeTimer.start()
	if value == States.CHASE:
		$donek/Truck.visible = true
		$donek/harmer/trucke.set_deferred("disabled", false)
		$donek/HitBoxComp/trucke.set_deferred("disabled", false)
		$donek/AnimatedSprite2D.position.y = -55
		$stateChangeTimer.wait_time = randf_range(5, 10)
		$stateChangeTimer.start()
	if value == States.SWORDE:
		swording()
		$stateChangeTimer.wait_time = 2
		$stateChangeTimer.start()
	if value == States.GRIMM:
		grimmCharges = 4
		$grimmTimer.start()
		if UnlimitedRulebook.player:
			if UnlimitedRulebook.player.global_position.x < global_position.x:
				goToPlaces("botright")
			else:
				goToPlaces("botleft")
		await get_tree().create_timer(0.5).timeout
		$donek/AnimatedSprite2D.play("nazi")
	state = value
func _physics_process(delta):
	if $HealthComp.health <= 20:
		get_tree().change_scene_to_file("res://Chars/transition_scene_3.tscn")
	if state != States.BALL:
		$donek/AnimatedSprite2D.rotation_degrees = 0
	turn()
	if state == States.CHASE:
		velocity.x = lerp(velocity.x, sign(UnlimitedRulebook.player.global_position.x-global_position.x) * speed * 2, 0.01)
		if not is_on_floor():
			velocity.y += 1.4 * delta * gravity
		if is_on_wall():
			velocity.x = sign(get_slide_collision(0).get_normal().x) * speed * 3
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
	elif state == States.SWORDE:
		move_and_slide()
	elif state == States.AURA:
		move_and_slide()
	elif state == States.GRIMM:
		move_and_slide()
		if not is_on_floor():
			velocity.y += 1.4 * delta * gravity
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
			velocity.y = 0
		"middle":
			var twink = get_tree().create_tween()
			twink.tween_property(self, "global_position", Vector2(320, 180), 0.5)
			velocity.y = 0
		"left":
			var twink = get_tree().create_tween()
			twink.tween_property(self, "global_position", Vector2(100, 180), 0.5)
			velocity.y = 0
		"botright":
			var twink = get_tree().create_tween()
			twink.tween_property(self, "global_position", Vector2(150, 300), 0.5)
			velocity.y = 0
		"botleft":
			var twink = get_tree().create_tween()
			twink.tween_property(self, "global_position", Vector2(550, 300), 0.5)
			velocity.y = 0

func swording():
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x < global_position.x:
			goToPlaces("right")
		else:
			goToPlaces("left")
	await get_tree().create_timer(0.5).timeout
	$swordAnimator.play("bladeSwing")

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
	if randi()%3 != 0:
		randomState()
	if state == States.IMPALE:
		impale()
		$impaleTimer.start()
	pass # Replace with function body.

func randomState():
	var rando = randi_range(0, 5)
	match rando:
		0:
			state = States.AURA
		1:
			state = States.BALL
		2:
			state = States.CHASE
		3:
			state = States.IMPALE
		4:
			state = States.SWORDE
		5:
			state = States.GRIMM
	print(state)


func _on_state_change_timer_timeout():
	if state == States.BALL:
		$donek/AnimatedSprite2D.rotation_degrees = 0
	randomState()
	pass # Replace with function body.


func _on_random_impaler_timeout():
	$randomImpaler.wait_time = randf_range(1, 8)
	var pillar = load("res://koylu_pillar.tscn").instantiate()
	pillar.global_position = Vector2(UnlimitedRulebook.player.global_position.x, 335)
	get_tree().root.add_child(pillar)
	$randomImpaler.start()
	pass # Replace with function body.


func _on_grimm_timer_timeout():
	var ucak = load("res://koylu_ucak.tscn").instantiate()
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x < global_position.x:
			ucak.global_position.x = global_position.x - 50
			ucak.direction = -1
		else:
			ucak.global_position.x = global_position.x - 50
			ucak.direction = 1
	if grimmCharges == 1 || grimmCharges == 3:
		ucak.global_position.y = global_position.y-10
	elif grimmCharges == 2 || grimmCharges == 4:
		ucak.global_position.y = global_position.y-60
	get_tree().root.add_child(ucak)
	grimmCharges -= 1
	if grimmCharges > 0:
		$grimmTimer.start()
	else:
		await get_tree().create_timer(1)
		randomState()
