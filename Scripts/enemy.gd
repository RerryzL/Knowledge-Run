extends Area2D

#var speed: float = 450.0 ga usah karena mau pake game manager (1 var utk semua)
const OFF_SCREEN: float = -200.0
const ENEMY_LIST = ["enemy_a", "enemy_b", "enemy_c"]

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if GameManager.game_pause == false:
		position.x -= GameManager.SCROLL_SPEED * delta
		check_off_screen()

func check_off_screen():
	if position.x < OFF_SCREEN:
		queue_free()

func _ready() -> void:
	var picked_enemy = ENEMY_LIST.pick_random()
	animated_sprite_2d.play(picked_enemy)
	animation_player.play(picked_enemy)
	GameManager.on_player_died.connect(on_game_lose)

func on_game_lose() -> void:
	set_physics_process(false)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#body.die()
		GameManager.on_player_died.emit()
