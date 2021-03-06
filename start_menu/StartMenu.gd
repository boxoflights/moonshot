extends Node2D

enum views {
	IDENT,
	MAINMENU,
	OPTIONS,
	CREDITS
}

var current_view = views.IDENT
var music = load("res://moonshot-intro.ogg")
var menu_change_sfx = load("res://SFX/menuChange.wav")

var init = false

var ident_time = 2

var dont_play_menu_change_sound = false

var intro = false
var intro_index = 0
var intro_time = 5
var intro_timer = intro_time

var credits = false
var credits_timer = 0
var credits_time = 5

func _ready():
	set_view(views.IDENT)
	SoundManager._apply_audio_settings()
	
	$OptionsMenu/Buttons/Master/HSlider.value = SettingsManager.get_setting("master")
	$OptionsMenu/Buttons/Music/HSlider.value = SettingsManager.get_setting("music")
	$OptionsMenu/Buttons/SFX/HSlider.value = SettingsManager.get_setting("sfx")
	$OptionsMenu/Buttons/Master/HSlider.connect("value_changed",self,"_on_Volume_value_changed")
	$OptionsMenu/Buttons/Music/HSlider.connect("value_changed",self,"_on_Volume_value_changed")
	$OptionsMenu/Buttons/SFX/HSlider.connect("value_changed",self,"_on_Volume_value_changed")
	for button in get_tree().get_nodes_in_group("buttons"):
		button.connect("focus_entered",self,"_play_ui_sound")
		button.connect("mouse_entered",self,"_play_ui_sound")

func _process(delta):
	if !init:
		ident_time -= delta
		if ident_time <= 0:
			set_view(views.MAINMENU)
			if(!SoundManager.is_music_playing()):
				SoundManager.play_music(music)
			init = true
			
	var comet = get_node("ParallaxBackground").get_node("ParallaxLayer2").get_node("Comet")
	if comet.position.y < 80:
		comet.position += Vector2(-150, 98).normalized() * (delta * 15)
	else:
		var crash = get_node("ParallaxBackground").get_node("ParallaxLayer2").get_node("Crash")
		if !crash.emitting:
			crash.emitting = true
			
	if intro:
		var t = $Intro.get_children()
		if intro_timer > 0:
			intro_timer -= delta
			if intro_timer >= intro_time - 1:
				t[intro_index].modulate = Color(1, 1, 1, intro_time - intro_timer)
			if intro_timer <= 1:
				t[intro_index].modulate = Color(1, 1, 1, intro_timer)
		else:
			if intro_index < $Intro.get_child_count() - 1:
				t[intro_index].visible = false
				intro_index += 1
				t[intro_index].visible = true
				intro_timer = intro_time
			else:
				intro = false
				fade_out()
				
	if credits:
		if credits_timer > 0:
			credits_timer -= delta
		else:
			credits = false
			set_view(views.MAINMENU)

func set_view(new_view):
	match new_view:
		views.IDENT:			
			$Camera.position = Vector2(0,-240)
		views.MAINMENU:
			$Camera.position = Vector2(0,0)
			dont_play_menu_change_sound = true
		views.OPTIONS:
			dont_play_menu_change_sound = true
			$Camera.position = Vector2(360,0)
		views.CREDITS:
			$Credits.visible = true
			credits = true
			credits_timer = credits_time
			$Camera.position = Vector2(0,-240)
	
	if current_view == views.IDENT:
		$Camera.smoothing_speed = 1
	else:
		$Camera.smoothing_speed = 10
	current_view = new_view

func _on_OPTIONS_pressed():
	SettingsManager.save_settings()
	set_view(views.OPTIONS)

func _on_OptionsBack_pressed():
	set_view(views.MAINMENU)

func _on_PLAY_pressed():
	intro = true
	$Intro.visible = true
	$MainMenu.visible = false
	
func fade_out():
	$Fade/Tween.interpolate_property($Fade,"modulate",
		Color(0,0,0,0),Color(0,0,0,1),0.5)
	$Fade/Tween.interpolate_callback(self,1,"_start_game")
	$Fade/Tween.start()

func _on_QUIT_pressed():
	get_tree().quit()

func _start_game():
	$Fade.modulate = Color(0,0,0,0)
	get_tree().change_scene("res://Main.tscn")


func _on_Volume_value_changed(value):
	SettingsManager.set_setting("master",$OptionsMenu/Buttons/Master/HSlider.value)
	SettingsManager.set_setting("music",$OptionsMenu/Buttons/Music/HSlider.value)
	SettingsManager.set_setting("sfx",$OptionsMenu/Buttons/SFX/HSlider.value)
	SettingsManager.save_settings()
	SoundManager._apply_audio_settings()

func _play_ui_sound():
	if(dont_play_menu_change_sound):
		dont_play_menu_change_sound = false
	else:
		SoundManager.play_sfx(menu_change_sfx)


func _on_CREDITS_pressed():
	set_view(views.CREDITS)
