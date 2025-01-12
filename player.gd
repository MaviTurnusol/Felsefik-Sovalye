extends CharacterBody2D

var form = 0
var momentum: float = 0
var runningSpeed = 300.0
var walkingSpeed = 300.0
var dash = false
var delayedDash = false
var isDashing = false
var dashSpeed = 800.0
var isAttacking = false
var jumpVelocity = 300.0
var wallSlideSpeed = 180.0

var jumpTimer: float = 0
var isJumping = false
var maxJumpHoldTime = 0.3
var jumpHoldDecay = 10
var jumpHoldForce = 1200.0

var nextAttack = null
var animEnded = true
var willAttack = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anima = $anima
@onready var dashCooldown = $dashCooldown
func _ready():
	UnlimitedRulebook.player = self
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity * delta * 2.5
		else:
			velocity.y += gravity * delta * 2
		
	handle_movement(delta)
	handle_walls()
	handle_attacks()
	handle_dashing()
	handle_stuff()
	move_and_slide()

func create_ghost():
	var animSprite = AnimatedSprite2D.new()
	animSprite.sprite_frames = anima.sprite_frames
	animSprite.play(anima.animation)
	animSprite.frame = anima.frame
	animSprite.pause()
	animSprite.global_position = anima.global_position
	animSprite.scale *= 2
	animSprite.flip_h = anima.flip_h
	animSprite.modulate = Color.BLACK
	get_tree().root.add_child(animSprite)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(animSprite, "modulate", Color.TRANSPARENT, 0.33)
	await get_tree().create_timer(0.33).timeout
	animSprite.queue_free()

func handle_dashing():
	if Input.is_action_just_pressed("dash"):
		if dash:
			isDashing = true
			var dashDirection = Vector2.ZERO
			if Input.is_action_pressed("right"): dashDirection.x = 1
			if Input.is_action_pressed("left"): dashDirection.x = -1
			if Input.is_action_pressed("up"): dashDirection.y = -1
			if Input.is_action_pressed("down"): dashDirection.y = 1
			velocity = dashDirection.normalized() * dashSpeed
			#create_ghost()
			await get_tree().create_timer(0.2).timeout
			dashCooldown.start()
			isDashing = false
			dash = false
	if is_on_floor():
		if dashCooldown.is_stopped():
			dash = true
		else:
			delayedDash = true
	if isDashing:
		if $ghostTimer.is_stopped():
			$ghostTimer.start()
			create_ghost()
	else:
		$ghostTimer.stop()

func handle_stuff():
	if anima.flip_h == false:
		$attackHitboxes.scale.x = 1
		$attackHitboxes.position = Vector2(0, 0)
	else:
		$attackHitboxes.scale.x = -1
		$attackHitboxes.position = Vector2(-10, 0)

func handle_attacks():
	if Input.is_action_just_pressed("attack"):
		if is_on_floor() && !isDashing:
			#isAttacking = true
			if form == 1:
				if anima.animation == "redairattack1" or anima.animation == "redattack1":
					nextAttack = "redattack2"
				elif anima.animation == "redairattack2" or anima.animation == "redattack2":
					nextAttack = "redattack3"
				elif anima.animation == "redairattack3" or anima.animation == "redattack3":
					nextAttack = "redattack2"
				else:
					nextAttack = "redattack1"
					anima.play(nextAttack)
					isAttacking = true
					nextAttack = null
			if form == 0:
				if anima.animation == "whiteattack1":
					nextAttack = "whiteattack2"
				elif anima.animation == "whiteattack2":
					nextAttack = "whiteattack3"
				elif anima.animation == "whiteattack3":
					nextAttack = "whiteattack2"
				else:
					nextAttack = "whiteattack1"
					anima.play(nextAttack)
					isAttacking = true
					nextAttack = null
		if !is_on_floor():
			if form == 1:
				if anima.animation == "redairattack1" or anima.animation == "redattack1":
					nextAttack = "redairattack2"
				elif anima.animation == "redairattack2" or anima.animation == "redattack2":
					nextAttack = "redairattack3"
				elif anima.animation == "redairattack3" or anima.animation == "redattack3":
					nextAttack = "redairattack2"
				else:
					nextAttack = "redairattack1"
					anima.play(nextAttack)
					isAttacking = true
					nextAttack = null
			else:
				if anima.animation == "whiteairattack1" or anima.animation == "whiteattack1":
					nextAttack = "whiteairattack2"
				elif anima.animation == "whiteairattack2" or anima.animation == "whiteattack2":
					nextAttack = "whiteairattack3"
				elif anima.animation == "whiteairattack3" or anima.animation == "whiteattack3":
					nextAttack = "whiteairattack2"
				else:
					nextAttack = "whiteairattack1"
					anima.play(nextAttack)
					isAttacking = true
					nextAttack = null
func handle_walls():
	if not is_on_floor() and is_on_wall():
		velocity.y = min(velocity.y, wallSlideSpeed)
		if Input.is_action_just_pressed("jump"):
			velocity.x = sign(get_slide_collision(0).get_normal().x) * runningSpeed * 2
			velocity.y = -jumpVelocity * 0.8
			velocity *= 1.2
			isJumping = true
			isAttacking = false
			jumpTimer = 0
			if velocity.y < 0:
				if form == 0:
					anima.play("whitejump")
				else:
					anima.play("redjump")

func handle_movement(delta):
	#if isDashing: return
	
	var input = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0)
	if input.x != 0:
		if !isAttacking && !isDashing:
			var speed = runningSpeed if Input.is_action_pressed("run") else walkingSpeed
			velocity.x = lerp(velocity.x, input.x * speed, 0.1)
		elif isAttacking:
			if is_on_floor():
				var speed = runningSpeed if Input.is_action_pressed("run") else walkingSpeed
				velocity.x = lerp(velocity.x, 0.0, 0.05)
		
		#Animations
		if is_on_floor() && !isDashing && !isAttacking:
			if form == 0:
				if abs(velocity.x) > 175:
					anima.play("whiterun")
				else:
					anima.play("whitewalk")
			if form == 1:
				if abs(velocity.x) > 175:
					anima.play("redrun")
				else:
					anima.play("redwalk")
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		if is_on_floor() && !isAttacking:
			if form == 0:
				anima.play("whiteidle")
			else:
				anima.play("redidle")

	if Input.is_action_pressed("left") && !isAttacking && !isDashing:
		anima.flip_h = true
		anima.position.x = 4
	elif Input.is_action_pressed("right") && !isAttacking && !isDashing:
		anima.flip_h = false
		anima.position.x = -6

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jumpVelocity
		if isDashing:
			velocity *= 1.2
		delayedDash = true
		isAttacking = false
		isJumping = true
		jumpTimer = 0
		if velocity.y < 0:
			if form == 0:
				anima.play("whitejump")
			else:
				anima.play("redjump")
	
	if Input.is_action_pressed("jump") and isJumping:
		if jumpTimer < maxJumpHoldTime:
			velocity.y -= jumpHoldForce * delta
			jumpTimer += delta
		else:
			isJumping = false
	
	if Input.is_action_just_released("jump"):
		isJumping = false
	
	if velocity.y > 0 && !is_on_wall() && !is_on_floor() && !isDashing && !isAttacking:
		if form == 0:
			anima.play("whitefall")
		else:
			anima.play("redfall")

func _on_anima_animation_finished():
	if anima.animation in ["whiteattack1", "whiteattack2", "whiteattack3", "redattack1", "redattack2", "redattack3"]:
		if nextAttack:
			anima.play(nextAttack)
			isAttacking = true
			animEnded = false
			nextAttack = null
			if Input.is_action_pressed("left") && !isDashing:
				anima.flip_h = true
				anima.position.x = 4
			elif Input.is_action_pressed("right") && !isDashing:
				anima.flip_h = false
				anima.position.x = -6
		else:
			if form == 1:
				anima.play("redidle")
			if form == 0:
				anima.play("whiteidle")
			isAttacking = false
	if anima.animation in ["whiteairattack1", "whiteairattack2", "whiteairattack3", "redairattack1", "redairattack2", "redairattack3"]:
		if nextAttack:
			anima.play(nextAttack)
			isAttacking = true
			animEnded = false
			nextAttack = null
			if Input.is_action_pressed("left") && !isDashing:
				anima.flip_h = true
				anima.position.x = 4
			elif Input.is_action_pressed("right") && !isDashing:
				anima.flip_h = false
				anima.position.x = -6
		else:
			if !is_on_floor():
				if form == 1:
					anima.play("redfall")
				if form == 0:
					anima.play("whitefall")
			else:
				if form == 1:
					anima.play("redidle")
				if form == 0:
					anima.play("whiteidle")
			isAttacking = false
	pass # Replace with function body.


func _on_anima_animation_looped():
	pass # Replace with function body.


func _on_dash_cooldown_timeout():
	if delayedDash:
		dash = true
		delayedDash = false
	pass # Replace with function body.


func _on_ghost_timer_timeout():
	create_ghost()
	if isDashing:
		$ghostTimer.start()
	pass # Replace with function body.
