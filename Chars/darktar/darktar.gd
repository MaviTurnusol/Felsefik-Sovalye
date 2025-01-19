extends CharacterBody2D

@onready var sprite = $Body/AnimatedSprite2D
@onready var wait_timer = $WaitTimer
@onready var change_direction_timer = $ChangeDirTimer

var attack = 5

var speed = 200.0
var direction = 0
var fuckindead = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum States { IDLE, RUN, ATTACK, FLY, SPIN}  
var state: States = States.IDLE

func _ready():
	$HarmBoxComp.atk = 50
	$Body/HitBoxComp.father = self
	$Body/HealthComp.father = self
	change_direction()

func _process(delta):
	if fuckindead:
		velocity.y += gravity * delta * 1.4
		var scaletwink = get_tree().create_tween()
		var colortwink = get_tree().create_tween()
		scaletwink.tween_property(self, "scale", Vector2(8, 8), 6)
		colortwink.tween_property(self, "modulate", Color.BLACK, 4)
		rotation_degrees += delta * randf_range(-256, 256)
		scaletwink.tween_callback(queue_free)
		move_and_slide()
	else:
		if state == States.IDLE:
			walking(delta)
			move_and_slide()
		elif state == States.RUN:
			running(delta)
			move_and_slide()
			if $Body/HealthComp.health <= $Body/HealthComp.MAX_HEALTH/2:
				velocity.y = -300
				state = States.FLY
				sprite.speed_scale = 1
				sprite.play("flip_more")
		elif state == States.FLY:
			fly()
			move_and_slide()
		elif state == States.SPIN:
			spin()
			move_and_slide()
			sprite.play("spin")
		elif state == States.ATTACK:
			attacking(delta)
		velocity.y += gravity * delta * 1.4
		turn()

func spin():
	sprite.play("spin")
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x - global_position.x < 0:
			velocity.x = lerp(velocity.x, -speed*3, 0.01)
		else:
			velocity.x = lerp(velocity.x, speed*3, 0.01)
	if is_on_wall():
		velocity.x *= -1.2
func fly():
	sprite.play("flip_more")
	if is_on_wall():
		velocity.x = sign(get_slide_collision(0).get_normal().x) * speed * 3
	await get_tree().create_timer(0.01).timeout
	if is_on_floor():
		state = States.SPIN
	if is_on_wall():
		velocity.x = sign(get_slide_collision(0).get_normal().x) * speed * 3

func running(delta):
	sprite.play("walk")
	sprite.speed_scale = 3
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x - global_position.x < 0:
			velocity.x = lerp(velocity.x, -speed, 0.05)
			#velocity.x = -speed
		else:
			velocity.x = lerp(velocity.x, speed, 0.05)
			#velocity.x = speed
	pass
func walking(delta):
	velocity.x = direction * speed
	
	if velocity.x == 0:
		sprite.stop()
		sprite.frame = 2
	else :
		if !sprite.is_playing():
			sprite.play("walk")

var rand_num = 1
func change_direction():
	direction = randf() * 2 - 1
	change_direction_timer.wait_time = randf_range(2.0, 3.0)
	if rand_num % 2 == 0:
		direction = abs(direction)
	else:
		direction = -abs(direction)
	rand_num += 1
	change_direction_timer.start()  

func _on_change_dir_timer_timeout():
	wait_timer.wait_time = randf_range(2.0, 4.0)
	direction = 0  
	wait_timer.start() 

func _on_wait_timer_timeout():
	change_direction()

func turn():
	if state != States.SPIN:
		if velocity.x > 0:
			$Body.scale.x = 1
		elif velocity.x < 0:
			$Body.scale.x = -1


func _on_vision_area_entered(area):
	if area.get_parent().is_in_group("player"):
		if state == States.IDLE:
			state = States.RUN
		#attack_ready()

func attack_ready():
	
	#$CollisionShape2D.global_position.y += 10
	#$Body/HitBoxComp/CollisionShape2D.global_position.y += 10
	#$HitArea/CollisionShape2D.global_position.y += 10
	
	velocity = Vector2.ZERO
	sprite.play("flip")
	await sprite.animation_finished
	sprite.play("spin")
	
	direction = sign(UnlimitedRulebook.player.global_position.x - global_position.x)
	velocity.x = direction * speed
	
	$Body/Vision.set_deferred("monitoring", false)

var on_floor = true 
var can_dash = true

func attacking(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		velocity.x *= 1.01
		#speed *= 1.1
		sprite.speed_scale = sprite.speed_scale * abs(velocity.x) / 100
		sprite.speed_scale = clamp(sprite.speed_scale,1,5)
		velocity.x = clamp(velocity.x, -500, 500)
		
		
		if collision.get_normal() == Vector2.UP:
			on_floor = true
			velocity.y = 0 
	
	if abs(UnlimitedRulebook.player.global_position.x - global_position.x) < 50 && on_floor && can_dash:
		sprite.play("flip_more")
		velocity.y = -speed * 1.2
		on_floor = false
		if UnlimitedRulebook.player.global_position.x - global_position.x < 0:
			velocity.x = -75
		else:
			velocity.x = 75
		await get_tree().create_timer(0.5).timeout 
		velocity.y = speed * 2
		velocity.x = speed * direction
		sprite.play("spin")
		can_dash = false
		await get_tree().create_timer(3).timeout 
		can_dash = true

func death():
	$CollisionShape2D.set_deferred("disabled", true)
	$HarmBoxComp.monitoring = false
	$Body/HitBoxComp.monitoring = false
	fuckindead = true
	velocity.y -= 500
	velocity.x = randf_range(-400, 400)
	sprite.pause()

func knockback(attacker):
	#var knockVelX = cos(attacker.global_position.angle_to(global_position))*300
	#var knockVelY = sin(attacker.global_position.angle_to(global_position))*300
	if state == States.RUN:
		velocity = attacker.global_position.direction_to(global_position).normalized()*600
	if state == States.SPIN:
		state = States.FLY
		velocity = attacker.global_position.direction_to(global_position).normalized()*900
