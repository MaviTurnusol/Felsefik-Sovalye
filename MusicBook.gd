extends Node2D

var currentMusic

func _process(delta):
	if currentMusic:
		if !currentMusic.playing:
			currentMusic.play()
		currentMusic.volume_db = UnlimitedRulebook.volume
	pass

func openMusic(music):
	for audio in get_children():
		if audio.name == music:
			if !audio.playing:
				audio.play()
				if audio.name == "menu":
					audio.seek(3.0)
				currentMusic = audio
		else:
			audio.stop()

func stopMusic():
	for audio in get_children():
		if audio is AudioStreamPlayer:
			audio.stop()

func glitchSound():
	if currentMusic:
		if is_instance_valid(currentMusic):
			currentMusic.pitch_scale = 0.8

func deglitchSound():
	if currentMusic:
		if is_instance_valid(currentMusic):
			currentMusic.pitch_scale = 1.0
