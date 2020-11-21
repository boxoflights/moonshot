extends KinematicBody2D

export (PackedScene) var Lazer

const GRAVITY = 98.0

export (int) var walk_speed = 32
export (int) var jet_speed = 32
export (float) var fire_cooldown_time = 0.5
export (float) var jet_impulse_time = 8

onready var sprite = get_node("AnimatedSprite")
onready var jet_left = get_node("JetLeft")
onready var jet_right = get_node("JetRight")

var velocity = Vector2()
var dir = "right"
var fire_cooldown_timer = 0
var jet_impulse_timer = 8

var jetpack_on = false

var knocked = null
var knock = 0

func knock_back(knocked_direction):
	knock = 0.5
	knocked = knocked_direction

func get_input(delta):	
	
	velocity.y = GRAVITY
	
	var anim = "walk"
	
	if Input.is_action_pressed('move_right'):
		dir = "right"
		velocity.x = walk_speed
	elif Input.is_action_pressed('move_left'):
		dir = "left"
		velocity.x = -walk_speed
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("jet_impulse"):
		if jet_impulse_timer > 0:
			if(!jetpack_on):
				$SFX/JetIntro.play()
			jetpack_on = true
			jet_impulse_timer -= delta
			jet_left.emitting = true
			jet_right.emitting = true
			velocity.y -= GRAVITY + jet_speed	
	else:
		if(jetpack_on):
			$SFX/Tween.interpolate_property($SFX/JetLoop,"volume_db",$SFX/JetLoop.volume_db,-90,0.5)
			$SFX/Tween.interpolate_callback($SFX/JetLoop,0.5,"stop")
			$SFX/Tween.start()
		jetpack_on = false
		if jet_impulse_timer < jet_impulse_time:
			jet_impulse_timer += delta
			if jet_impulse_timer > jet_impulse_time:
				jet_impulse_timer = jet_impulse_time
		jet_left.emitting = false
		jet_right.emitting = false
	
	if velocity.y < 0:
		anim = "jet"
	elif velocity.x == 0:
		anim = "idle"
	
	sprite.play(anim + "_" + dir)
	
	if fire_cooldown_timer > 0:
		fire_cooldown_timer -= delta
	
	if Input.is_action_pressed("fire"):
		if fire_cooldown_timer <= 0:
			var lazer = Lazer.instance()
			owner.add_child(lazer)
			if dir == "right":
				lazer.direction = 1
				lazer.transform = $MuzzleRight.global_transform
			else:
				lazer.direction = -1
				lazer.transform = $MuzzleLeft.global_transform
				lazer.rotation_degrees = 180
			fire_cooldown_timer = fire_cooldown_time
	
	if knock > 0:
		velocity += knocked * 64
		knock -= delta
		if knock as int % 2 == 0:
			$AnimatedSprite.modulate = Color(10, 10, 10)
		else:
			$AnimatedSprite.modulate = Color(0, 0, 0)
	elif knocked != null:
		$AnimatedSprite.modulate = Color(1, 1, 1)
		knock = 0
		knocked = null

func _physics_process(delta):
	get_input(delta)
	move_and_slide(velocity, Vector2(0, -1))

func _on_JetIntro_finished():
	if(jetpack_on):
		$SFX/JetLoop.volume_db = 0
		$SFX/JetLoop.play()
