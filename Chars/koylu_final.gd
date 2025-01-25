extends CharacterBody2D

enum States {ENTER, THROW, STAB, ZANPAKUTO}  
var state: States = States.ENTER : set = setState
var floating = true

func setState(value):
	if value == States.THROW:
		if is_instance_valid(UnlimitedRulebook.player):
			if UnlimitedRulebook.player.global_position.x < global_position.x:
				goSide("left")
			else:
				goSide("left")
			floating = false
		$throwMer.start()
	if value == States.STAB:
		if UnlimitedRulebook.player:
			if UnlimitedRulebook.player.global_position.x < global_position.x:
				goSide("left")
			else:
				goSide("right")
			floating = false
		$uselessTimer.start()
		spawnFloorCutter()
	if value == States.ZANPAKUTO:
		if is_instance_valid(UnlimitedRulebook.player):
			if UnlimitedRulebook.player.global_position.x < global_position.x:
				goSide("left")
			else:
				goSide("right")
			floating = false
		$getsugaTimer.start()
		$animator.play("getsugaTenshou")
	state = value

func _ready():
	state = States.ZANPAKUTO
	
func _physics_process(delta):
	if state == States.THROW:
		followYAxis()
	if state == States.STAB:
		followYAxis()
	if state == States.ZANPAKUTO:
		floating = false
		if !$animator.is_playing():
			global_position.y = lerp(global_position.y, UnlimitedRulebook.player.global_position.y, 0.01)
			global_position.x = lerp(global_position.x, UnlimitedRulebook.player.global_position.x, 0.01)
	turn()
	pass

func followYAxis():
	global_position.y = lerp(global_position.y, UnlimitedRulebook.player.global_position.y, 0.01)
	#global_position.y = UnlimitedRulebook.player.global_position.y

func spawnFloorCutter():
	var castArray = []
	for i in randi_range(3,5):
		var raycast = RayCast2D.new()
		raycast.target_position = Vector2(cos(randf_range(0, 360)), sin(randf_range(0, 360))).normalized()*400
		raycast.collision_mask = 13
		if UnlimitedRulebook.player:
			UnlimitedRulebook.player.add_child(raycast)
			raycast.position.y -= 50
			castArray.append(raycast)
	await get_tree().create_timer(0.5).timeout
	for caster in castArray:
		if caster.is_colliding():
			var sword = load("res://Chars/floor_cutter.tscn").instantiate()
			sword.global_position = caster.get_collision_point()
			print(UnlimitedRulebook.player.global_position)
			get_tree().root.add_child(sword)
			sword.rotation = Vector2.ZERO.angle_to_point(caster.target_position)
			sword.rotation -= PI/2
			caster.queue_free()


func _on_useless_timer_timeout():
	if state != States.STAB:
		return
	spawnFloorCutter()
	$uselessTimer.start()

func goSide(side):
	match side:
		"left":
			var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
			twink.tween_property(self, "position:x", 50, 0.75)
		"right":
			var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
			twink.tween_property(self, "position:x", 590, 0.75)

func turn():
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x < global_position.x:
			$sprites.scale.x = 1
		else:
			$sprites.scale.x = -1

func flyFloat():
	var twing = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	twing.tween_property(self, "position:y", position.y - 5, 0.75)
	twing.tween_property(self, "position:y", position.y + 5, 0.75)


func _on_floater_timeout():
	if floating:
		flyFloat()


func _on_throw_mer_timeout():
	if state != States.THROW:
		return
	var swoord = load("res://Chars/flying_sword.tscn").instantiate()
	swoord.global_position.y = global_position.y + randf_range(-50, 50)
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x < global_position.x:
			swoord.global_position.x = global_position.x + 50
			#swoord.rotation_degrees += 90
			swoord.look_at(UnlimitedRulebook.player.global_position)
		else:
			swoord.global_position.x = global_position.x + 50
			#swoord.rotation_degrees -= 90
			swoord.look_at(UnlimitedRulebook.player.global_position)
	swoord.rotation_degrees += 180
	get_tree().root.add_child(swoord)
	print(swoord.rotation_degrees)
	$throwMer.start()


func _on_state_changer_timeout():
	match state:
		States.THROW:
			if randi()%2 == 0:
				state = States.STAB
			else:
				state = States.ZANPAKUTO
		States.STAB:
			if randi()%2 == 0:
				state = States.THROW
			else:
				state = States.ZANPAKUTO
		States.ZANPAKUTO:
			if randi()%2 == 0:
				state = States.THROW
			else:
				state = States.STAB


func _on_getsuga_timer_timeout():
	if state != States.ZANPAKUTO:
		return
	global_position.y = lerp(global_position.y, UnlimitedRulebook.player.global_position.y, 0.1)
	#global_position.x = lerp(global_position.x, UnlimitedRulebook.player.global_position.x*1.1, 0.01)
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.global_position.x < global_position.x:
			var twing = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
			twing.tween_property(self, "global_position:x", UnlimitedRulebook.player.global_position.x - 100, 0.75)
		else:
			var twing = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
			twing.tween_property(self, "global_position:x", UnlimitedRulebook.player.global_position.x + 100, 0.75)
			
	$animator.play("getsugaTenshou")
	$getsugaTimer.start()
	pass # Replace with function body.
