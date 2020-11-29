extends Area2D

enum STATES {
	REPAIRING_0,
	REPAIRING_1,
	REPAIRING_2,
	REPAIRED,
	DOOR_OPENING,
	DOOR_CLOSING,
	BLASTOFF,
}

var item_return_sound = load("res://SFX/return-pickup.wav")
var state
var velocity_y = 0
var acceleration = 32

func _ready():
	set_state(STATES.REPAIRING_2)

func set_state(new_state):
	match new_state:
		STATES.REPAIRING_0:
			$AnimatedSprite.play("default")
			$Smoke/Smoke1.emitting = true
			$Smoke/Smoke2.emitting = true
			$Smoke/Smoke3.emitting = true
			$Smoke/Smoke4.emitting = true
			state = new_state
		STATES.REPAIRING_1:
			$AnimatedSprite.play("repairing_1")
			$Smoke/Smoke1.emitting = true
			$Smoke/Smoke2.emitting = true
			$Smoke/Smoke3.emitting = false
			$Smoke/Smoke4.emitting = true
			state = new_state
		STATES.REPAIRING_2:
			$AnimatedSprite.play("repairing_2")
			$Smoke/Smoke1.emitting = false
			$Smoke/Smoke2.emitting = false
			$Smoke/Smoke3.emitting = false
			$Smoke/Smoke4.emitting = true
			state = new_state
		STATES.REPAIRED:
			$AnimatedSprite.play("repaired")
			$Smoke/Smoke1.emitting = false
			$Smoke/Smoke2.emitting = false
			$Smoke/Smoke3.emitting = false
			$Smoke/Smoke4.emitting = false
			state = new_state
		STATES.DOOR_OPENING:
			$AnimatedSprite.play("repaired_door_opening")
			$Smoke/Smoke1.emitting = false
			$Smoke/Smoke2.emitting = false
			$Smoke/Smoke3.emitting = false
			$Smoke/Smoke4.emitting = false
			state = new_state
		STATES.DOOR_CLOSING:
			$AnimatedSprite.play("repaired_door_closing")
			$Smoke/Smoke1.emitting = false
			$Smoke/Smoke2.emitting = false
			$Smoke/Smoke3.emitting = false
			$Smoke/Smoke4.emitting = false
			state = new_state
		STATES.BLASTOFF:
			$AnimatedSprite.play("repaired")
			$Smoke/Smoke1.emitting = false
			$Smoke/Smoke2.emitting = false
			$Smoke/Smoke3.emitting = false
			$Smoke/Smoke4.emitting = false
			state = new_state
			blast_off()
		
			
			
func blast_off():
	$LiftOffSound.volume_db = -90
	$Tween.interpolate_property(
		self,"position",
		position,Vector2(position.x,-100),
		3,Tween.TRANS_EXPO,Tween.EASE_IN)
	$Tween.interpolate_property($LiftOffSound,"volume_db",-90,0,0.5)
	$Tween.start()
	$Fire1.emitting = true
	$Fire2.emitting = true
	$LiftOffSmokeLeft.emitting = true
	$LiftOffSmokeRight.emitting = true
	$LiftOffSmokeCenter.emitting = true
	$LiftOffSound.play()

func _on_Rocket_body_entered(body):
	if body.is_in_group("player"):
		print("ROCKET")
		if body.has_item:
			SoundManager.play_sfx(item_return_sound)
			print("RETURNED")
			body.has_item = false
			body.items_returned += 1
			set_state(state + 1)
