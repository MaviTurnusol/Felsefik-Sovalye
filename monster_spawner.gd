extends Node2D

var spawnpos1
var spawnpos2
var waveValue
var waveCd
var monsterCount = 0
var monsters = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4]
var queue = []
var canSkip = false
func _ready():
	for child in get_children():
		if child.is_in_group("monster"):
			child.queue_free()
	await get_tree().create_timer(2).timeout
	wavey()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if UnlimitedRulebook.infoLabel:
		UnlimitedRulebook.infoLabel.text = "WAVE " + str(UnlimitedRulebook.wave)
	if queue.is_empty():
		for child in get_children():
			if child.is_in_group("monster"):
				return
		if $waveTimer.time_left > 1.0 && $waveTimer.time_left < 20.0:
			$waveTimer.stop()
			if $waveTimer.is_stopped():
				wavey()
	if UnlimitedRulebook.wave == 16:
		get_tree().change_scene_to_file("res://Chars/transition_scene_2.tscn")
	pass


func _on_cd_timeout():
	spawn()

func _on_wave_timer_timeout():
	wavey()

func wavey():
	$waveTimer.wait_time = 15.0 + round(sqrt(UnlimitedRulebook.wave))
	UnlimitedRulebook.wave += 1
	$"../../waveAnimator".play("WaveFall")
	waveValue = 3+round(sqrt(UnlimitedRulebook.wave))*2
	var i = 0
	while i < waveValue:
		var monster =  monsters.pick_random()
		if monster <= waveValue:
			i+=monster
			queue.append(monster)
			monsterCount+=1
	waveCd = 15/monsterCount
	$cd.wait_time = waveCd
	spawn()
	$waveTimer.start()

func spawn():
	print(queue)
	var spawn = queue.pop_back()
	monsterCount -= 1
	print(UnlimitedRulebook.wave)
	match spawn:
		1:
			print("spawn armoz")
			var armoz = load("res://Chars/armoz/armoz.tscn").instantiate()
			if randi()%2 == 0:
				armoz.position = Vector2(-85, 250)
			else:
				armoz.position = Vector2(715, 250)
			add_child(armoz)
		2:
			if randi()%2 == 0:
				for i in 3:
					var armoz = load("res://Chars/armoz/armoz.tscn").instantiate()
					if randi()%2 == 0:
						armoz.position = Vector2(-85, 300-i*20)
					else:
						armoz.position = Vector2(715, 300-i*20)
					add_child(armoz)
			else:
				print("spawn darkzip")
				var darkzip = load("res://Chars/darkzip/darkzip.tscn").instantiate()
				if randi()%2 == 0:
					darkzip.position = Vector2(-85, 250)
				else:
					darkzip.position = Vector2(715, 250)
				add_child(darkzip)
		3:
			var darktar = load("res://Chars/darktar/darktar.tscn").instantiate()
			if randi()%2 == 0:
				darktar.position = Vector2(-85, 250)
			else:
				darktar.position = Vector2(715, 250)
			add_child(darktar)
		4:
			for i in 2:
				var darktar = load("res://Chars/darktar/darktar.tscn").instantiate()
				if i == 1:
					darktar.position = Vector2(-85, 250)
				else:
					darktar.position = Vector2(715, 250)
				add_child(darktar)
	if !queue.is_empty():
		$cd.wait_time = waveCd
		$cd.start()
