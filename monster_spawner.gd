extends Node2D

var spawnpos1
var spawnpos2
var waveValue
var waveCd
var monsterCount = 0
var monsters = [1, 2, 2, 1, 1, 3]
var queue = []
var canSkip = false
func _ready():
	for child in get_children():
		if child.is_in_group("monster"):
			child.queue_free()
	wavey()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if UnlimitedRulebook.infoLabel:
		UnlimitedRulebook.infoLabel.text = str(UnlimitedRulebook.wave) + " " + str(round($waveTimer.time_left))
	if queue.is_empty():
		for child in get_children():
			if child.is_in_group("monster"):
				return
		if $waveTimer.time_left > 1.0 && $waveTimer.time_left < 20.0:
			$waveTimer.stop()
			if $waveTimer.is_stopped():
				wavey()
	pass


func _on_cd_timeout():
	spawn()

func _on_wave_timer_timeout():
	wavey()

func wavey():
	$waveTimer.wait_time = 30.0 + round(sqrt(UnlimitedRulebook.wave))
	UnlimitedRulebook.wave += 1
	waveValue = 3+round(sqrt(UnlimitedRulebook.wave))*2
	var i = 0
	while i < waveValue:
		var monster =  monsters.pick_random()
		if monster <= waveValue:
			i+=monster
			queue.append(monster)
			monsterCount+=1
	waveCd = 20/monsterCount
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
				print("spawn darktar")
				var darktar = load("res://Chars/darktar/darktar.tscn").instantiate()
				if randi()%2 == 0:
					darktar.position = Vector2(-85, 250)
				else:
					darktar.position = Vector2(715, 250)
				add_child(darktar)
			else:
				print("spawn darkzip")
				var darkzip = load("res://Chars/darkzip/darkzip.tscn").instantiate()
				if randi()%2 == 0:
					darkzip.position = Vector2(-85, 250)
				else:
					darkzip.position = Vector2(715, 250)
				add_child(darkzip)
		3:
			for i in 3:
				var armoz = load("res://Chars/armoz/armoz.tscn").instantiate()
				if randi()%2 == 0:
					armoz.position = Vector2(-85, 300-i*20)
				else:
					armoz.position = Vector2(715, 300-i*20)
				add_child(armoz)
	if !queue.is_empty():
		$cd.wait_time = waveCd
		$cd.start()
