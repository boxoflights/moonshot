extends Node2D

var music = load("res://moonshot-theme.ogg")
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	state = $Rocket.state
	SoundManager.play_music(music,0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD.set_jetpack_percent($Player.get_jetpack_percent())
	$HUD.set_fire_percent($Player.get_fire_percent())
	$HUD.set_health_percent($Player.get_health_percent())
	$HUD.set_current_lives($Player.lives)
	
	if $Rocket.state != state:
		for c in $Spawns.get_children():
			c.spawn()
		state = $Rocket.state

