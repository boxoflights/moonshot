extends Node

var silence_vol = -80

func play_music(music: AudioStream,fade_time = 0, vol = -20):
	stop_music(0)
	$Music/Main.stream = music
	$Music/Main.volume_db = silence_vol
	$Music/Main.play()
	$Music/Tween.interpolate_property($Music/Main,"volume_db",
		$Music/Main.volume_db,vol,fade_time)
	$Music/Tween.start()
	
func stop_music(fade_time = 0):
	$Music/Main.stop()

func switch_music(music: AudioStream,fade_time = 0, vol = -20):
	if(!is_music_playing()):
		play_music(music,fade_time,vol)
	else:
		$Music/Tween.interpolate_callback(self,fade_time,
			"play_music",music,fade_time,vol)
		$Music/Tween.interpolate_property($Music/Main,"volume_db",
			$Music/Main.volume_db,silence_vol,fade_time)
		$Music/Tween.start()

func is_music_playing():
	return $Music/Main.is_playing()
	
func get_current_music():
	return $Music/Main.stream

func play_sfx(sfx: AudioStream, vol = -20, autoplay = true):
	var player = null
	for audioSFX in $SFX.get_children():
		if !audioSFX.is_playing():
			player = audioSFX
			break
	if(player == null):
		player = AudioStreamPlayer.new()
		$SFX.add_child(player)
	player.stream = sfx
	player.volume_db = vol
	if(autoplay):
		player.play()
	return player

func play_2D_sfx(sfx: AudioStream, pos: Vector2, vol = -20, autoplay = true):
	var player = null
	for audioSFX in $SFX2D.get_children():
		if !audioSFX.is_playing():
			player = audioSFX
			break
	if(player == null):
		player = AudioStreamPlayer2D.new()
		$SFX2D.add_child(player)
	player.stream = sfx
	player.position = pos
	if(autoplay):
		player.play()
	return player
