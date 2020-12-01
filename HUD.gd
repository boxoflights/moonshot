extends CanvasLayer

var current_lives = 0
var lives_icon = load("res://ui/ui.life.png")

func _ready():
	$Theme/GoBack.modulate = Color(1,1,1,0)
	$Theme/InstructionPanel.modulate = Color(1,1,1,0)

func set_has_item(has = false):
	if(has && !$uirepairkit.visible):
		flash_go_back()
		flash_instructions("I should return this to the rocket.")
	$uirepairkit.visible = has


func set_jetpack_percent(v):
	$Theme/JetPack/ProgressBar.value = v

func set_fire_percent(v):
	$Theme/Laser/ProgressBar.value = 1.0 - v
	
func set_current_lives(new_lives):
	if(new_lives == current_lives):
		return
	current_lives = new_lives
	
	#empty
	for k in $Theme/Lives/Icons.get_children():
		$Theme/Lives/Icons.remove_child(k)

	#add
	for i in current_lives:
		var l = TextureRect.new()
		l.texture = lives_icon
		$Theme/Lives/Icons.add_child(l)

func set_health_percent(v):
	$Theme/Health/ProgressBar.value = v

func game_over():
	$Theme/EndGame/Title.text = "GAMEOVER"
	$Theme/EndGame.show()
	
func game_win():
	$Theme/EndGame/Title.text = "YOU ESCAPED!"
	$Theme/EndGame.show()


func _return_to_menu():
		get_tree().change_scene("res://start_menu/StartMenu.tscn")

func flash_go_back():
	$Theme/GoBack/Tween.interpolate_property($Theme/GoBack,"modulate",
		Color(1,1,1,0),Color(1,1,1,1),0.5)
	$Theme/GoBack/Tween.interpolate_property($Theme/GoBack,"modulate",
		Color(1,1,1,1),Color(1,1,1,0),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0.5)
	$Theme/GoBack/Tween.interpolate_property($Theme/GoBack,"modulate",
		Color(1,1,1,0),Color(1,1,1,1),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,1)
	$Theme/GoBack/Tween.interpolate_property($Theme/GoBack,"modulate",
		Color(1,1,1,1),Color(1,1,1,0),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,1.5)
	$Theme/GoBack/Tween.interpolate_property($Theme/GoBack,"modulate",
		Color(1,1,1,0),Color(1,1,1,1),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,2)
	$Theme/GoBack/Tween.interpolate_property($Theme/GoBack,"modulate",
		Color(1,1,1,1),Color(1,1,1,0),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,2.5)
	$Theme/GoBack/Tween.start()
	
func cannot_pickup():
	flash_go_back()
	flash_instructions("I can only carry one repair module.")

func flash_instructions(instructions):
	$Theme/InstructionPanel/Label.text = instructions
	$Theme/InstructionPanel/Tween.interpolate_property($Theme/InstructionPanel,"modulate",
		Color(1,1,1,0),Color(1,1,1,1),0.5)
	$Theme/InstructionPanel/Tween.interpolate_property($Theme/InstructionPanel,"modulate",
		Color(1,1,1,1),Color(1,1,1,0),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,2.5)
	$Theme/InstructionPanel/Tween.start()
