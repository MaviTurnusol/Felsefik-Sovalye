extends Node2D

func _ready():
	MusicBook.openMusic("arena")
	MusicBook.deglitchSound()
