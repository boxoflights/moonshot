extends KinematicBody2D

export (PackedScene) var Lazer

const GRAVITY = 48.0

export (int) var walk_speed = 32
export (int) var jet_speed = 32
export (float) var fire_cooldown_time = 0.5
export (float) var jet_impulse_time = 4
export (float) var health_regeneration_speed = 0.5

onready var sprite = get_node("AnimatedSprite")
onready var jet_left = get_node("JetLeft")
onready var jet_right = get_node("JetRight")

var velocity = Vector2()
var dir = "right"
var fire_cooldown_timer = 0
var jet_impulse_timer = jet_impulse_time
var health = 100
var max_health = 100
var lives = 3
var has_item = false
var items_returned = 0

var jetpack_on = false

var knocked = null
var knock_amount = 0
var knock = 0
var flicker = false
var flicker_time = 0

var block_input = false

var dying = false
var dead = false
var last_checkpoint = position

func _ready():
	last_checkpoint = position

func get_jetpack_percent():
	return (1.0 / jet_impulse_time) * jet_impulse_timer
	
func get_fire_percent():
	return (1.0 / fire_cooldown_time) * fire_cooldown_timer

func get_health_percent():
	return (1.0 / max_health) * health

func knock_back(knocked_direction, amount, time):
	knock = time
	knock_amount = amount
	knocked = knocked_direction

func take_damage(dmg):
	health -= dmg
	flicker_time = 0.25

func regenerate_health(delta):
	if(health < max_health):
		health += health_regeneration_speed * delta
		if(health > max_health):
			health = max_health

func do_end_sequence():
	block_input = true
	$AnimatedSprite.play("jet_"+dir)
	turn_jetpack_on()
	pass

func disappear():
	visible = false
	turn_jetpack_off()
	
func turn_jetpack_on():
	$SFX/JetIntro.play()
	$SFX/JetLoop.play()
	$SFX/Tween.stop_all()
	$SFX/Tween.interpolate_property($SFX/JetLoop,"volume_db",-90,0,0.15)
	$SFX/Tween.start()
	jet_left.emitting = true
	jet_right.emitting = true

func turn_jetpack_off():
	$SFX/Tween.stop_all()
	$SFX/Tween.interpolate_property($SFX/JetLoop,"volume_db",0,-90,0.5)
	$SFX/Tween.interpolate_callback($SFX/JetLoop,0.5,"stop")
	$SFX/Tween.start()
	jet_left.emitting = false
	jet_right.emitting = false
	jetpack_on = false
	
func die():
	print("DIE")
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)
	lives -= 1
	dying = true
	sprite.play("death_" + dir)

func respawn():
	if lives > 0:
		print("RESPAWN")
		dying = false
		position = last_checkpoint
		visible = true
		health = 100
	else:
		print("GAME OVER")
		dead = true
		$AnimatedSprite.stop()
		disappear()

func get_input(delta):
	if(block_input): return
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
				turn_jetpack_on()
			jetpack_on = true
			jet_impulse_timer -= delta

			velocity.y -= GRAVITY + jet_speed
		else:
			turn_jetpack_off()
	else:
		if(jetpack_on):
			turn_jetpack_off()
		if jet_impulse_timer < jet_impulse_time:
			if is_on_floor():
				jet_impulse_timer += delta  * 4
			if jet_impulse_timer > jet_impulse_time:
				jet_impulse_timer = jet_impulse_time
		jet_left.emitting = false
		jet_right.emitting = false
	
	if !is_on_floor():
		anim = "jet"
	elif velocity.x == 0:
		anim = "idle"
	
	if(
		anim == "idle" &&
		sprite.animation == "fire_" + dir &&
		fire_cooldown_timer > 0
	):
		pass
	else:
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
				$MuzzleFlashRight.emitting = true
				if(anim == "idle"):
					sprite.play("fire_right")
			else:
				lazer.direction = -1
				lazer.transform = $MuzzleLeft.global_transform
				$MuzzleFlashLeft.emitting = true
				lazer.rotation_degrees = 180
				if(anim == "idle"):
					sprite.play("fire_left")
			fire_cooldown_timer = fire_cooldown_time
	
	if knock > 0:
		velocity += knocked * knock_amount
		knock -= delta		
	elif knocked != null:
		knock = 0
		knocked = null
		knock_amount = 0
	
	if flicker_time > 0:
		flicker_time -= delta	
		if flicker:
			$AnimatedSprite.modulate = Color(10, 10, 10)
		else:
			$AnimatedSprite.modulate = Color(0, 0, 0)
		flicker = !flicker
	else:
		$AnimatedSprite.modulate = Color(1, 1, 1)

func _physics_process(delta):
	if !dead && !dying:
		if health <= 0:
			die()
		elif visible:
			regenerate_health(delta)
			get_input(delta)
			move_and_slide(velocity, Vector2(0, -1))
			if position.y > 290:
				health = 0


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.begins_with("death"):
		respawn()
