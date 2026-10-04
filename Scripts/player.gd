extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio
@onready var hurt_audio: AudioStreamPlayer2D = $HurtAudio

const GRAVITY : float = 2000.0
const JUMP_FORCE = -850.0 #negatif because its supposed to go up
var is_alive = false

func _ready() -> void:
	is_alive = true
	GameManager.on_player_died.connect(die)

func die() -> void:
	hurt_audio.play()
	is_alive = false

func _physics_process(delta: float) -> void:
	if GameManager.game_pause == false:
		velocity.y += GRAVITY * delta
		if is_alive:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_FORCE
				jump_audio.play()
			update_animation()
		move_and_slide() 

func update_animation() -> void:
	if is_on_floor():
		animated_sprite_2d.play("run")
	if is_on_floor() == false:
		animated_sprite_2d.play("jump")
