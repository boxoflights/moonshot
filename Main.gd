extends Node2D

var music = load("res://moonshot-theme.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.play_music(music,0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD.set_jetpack_percent($Player.get_jetpack_percent())
	$HUD.set_fire_percent($Player.get_fire_percent())
	$HUD.set_current_lives($Player.lives)
