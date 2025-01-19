extends Node2D

var spawnpos1
var spawnpos2
var waveValue
var waveCd
var monsterCount = 0
var monsters = [1, 2, 2, 3]
var queue = []
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cd_timeout():
	print(queue)
	var spawn = queue.pop_back()
	monsterCount -= 1
	print(UnlimitedRulebook.wave)
	match spawn:
		1:
			print("spawn armoz")
		2:
			if randi()%2 == 0:
				print("spawn darktar")
			else:
				print("spawn darkzip")
		3:
			print("spawn devzip")
	if !queue.is_empty():
		$cd.wait_time = waveCd
		$cd.start()

func _on_wave_timer_timeout():
	UnlimitedRulebook.wave += 1
	waveValue = 3+sqrt(UnlimitedRulebook.wave)
	var i = 0
	while i < waveValue:
		var monster =  monsters.pick_random()
		if monster <= waveValue:
			i+=monster
			queue.append(monster)
			monsterCount+=1
	waveCd = 10/monsterCount
	$cd.wait_time = waveCd
	$cd.start()
	pass # Replace with function body.
