extends CharacterBody2D

@onready var sprite = $Body/AnimatedSprite2D
@onready var wait_timer = $WaitTimer
@onready var change_direction_timer = $ChangeDirTimer


var attack = 5

var speed = 100
var direction = 0


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum States { IDLE , ATTACK}  
var state: States = States.IDLE

func _ready():
	$HarmBoxComp.atk = 5
	change_direction()

func _process(delta):
	if state == States.IDLE:
		walking(delta)
		move_and_slide()
	elif state == States.ATTACK:
		attacking(delta)
	velocity.y += gravity * delta
	turn()


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
	if velocity.x > 0:
		$Body.scale.x = 1
	elif velocity.x < 0:
		$Body.scale.x = -1


func _on_vision_area_entered(area):
	if area.get_parent().is_in_group("player"):
		state = States.ATTACK
		attack_ready()

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
		sprite.speed_scale = sprite.speed_scale * abs(velocity.x) / 100
		sprite.speed_scale = clamp(sprite.speed_scale,1,5)
		velocity.x = clamp(velocity.x, -500, 500)
		
		
		if collision.get_normal() == Vector2.UP:
			on_floor = true
			velocity.y = 0 
	
	if abs(UnlimitedRulebook.player.global_position.x - global_position.x) < 50 && on_floor && can_dash:
		sprite.play("flip_more")
		velocity.y = -speed * 5
		on_floor = false
		if UnlimitedRulebook.player.global_position.x - global_position.x < 0:
			velocity.x = -75
		else:
			velocity.x = 75
		await get_tree().create_timer(0.5).timeout 
		velocity.y = speed * 7
		sprite.play("spin")
		can_dash = false
		await get_tree().create_timer(3).timeout 
		can_dash = true
