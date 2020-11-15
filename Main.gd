extends Node2D

var music = load("res://moonshot-theme.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.play_music(music,0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
