extends Area2D
signal on_picked_up
@onready var gambar = $AnimatedSprite2D

const OFF_SCREEN: float = -200.0

func _physics_process(delta: float) -> void:
	if GameManager.game_pause == false:
		position.x -= GameManager.SCROLL_SPEED * delta
		check_off_screen()

func check_off_screen():
	if position.x < OFF_SCREEN:
		queue_free()

func _ready() -> void:
	GameManager.on_player_died.connect(on_game_lose)

func on_game_lose() -> void:
	set_physics_process(false)


func _on_body_entered(body: Node2D) -> void:
	print("books collected")
	on_picked_up.emit()
