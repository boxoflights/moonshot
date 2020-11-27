extends Node2D

var music = load("res://moonshot-theme.ogg")
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	state = $Rocket.state
	SoundManager.play_music(music,0.5)

func respawn():
	for c in $Spawns.get_children():
			c.spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.health <= 0:
		if $Player.lives > 0:
			$Player.lives -= 1
			$Player.position = $Rocket.position
	
	$HUD.set_jetpack_percent($Player.get_jetpack_percent())
	$HUD.set_fire_percent($Player.get_fire_percent())
	$HUD.set_health_percent($Player.get_health_percent())
	$HUD.set_current_lives($Player.lives)
	
	if $Rocket.state != state:
		respawn()
		state = $Rocket.state
