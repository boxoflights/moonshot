extends Node2D

var music = load("res://moonshot-theme.ogg")
var state
var complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	state = $Rocket.state
	SoundManager.play_music(music,0.5)

func respawn():
	for c in $Spawns.get_children():
			c.spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !complete:
		if $Rocket.state != state:
			respawn()
			state = $Rocket.state
			
		if state == $Rocket.STATES.REPAIRED:
			complete = true
			$Player.do_end_sequence()
			var tween = Tween.new()
			tween.interpolate_property($Player,"position",$Player.position,$Rocket/DoorPosition.get_global_position(),1.5)
			tween.interpolate_callback($Rocket,0.3,"set_state",$Rocket.STATES.DOOR_OPENING)
			tween.interpolate_callback($Player,1.5,"disappear")
			tween.interpolate_callback($Rocket,1.5,"set_state",$Rocket.STATES.DOOR_CLOSING)
			tween.interpolate_callback($Rocket,3.5,"set_state",$Rocket.STATES.BLASTOFF)
			get_parent().add_child(tween)
			tween.start()
		else:
			if $Player.health <= 0:
				if $Player.lives > 0:
					$Player.lives -= 1
					$Player.health = 100
					$Player.position = $Rocket.position
		
			$HUD.set_jetpack_percent($Player.get_jetpack_percent())
			$HUD.set_fire_percent($Player.get_fire_percent())
			$HUD.set_health_percent($Player.get_health_percent())
			$HUD.set_current_lives($Player.lives)
