extends CanvasLayer

var current_lives = 0
var lives_icon = load("res://ui/ui.life.png")

func set_has_item(has = false):
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
	$Theme/EndGame/Title.text = "YOU WIN!"
	$Theme/EndGame.show()


func _return_to_menu():
		get_tree().change_scene("res://start_menu/StartMenu.tscn")
