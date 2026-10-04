extends ParallaxBackground

func _process(delta):
	scroll_offset.x -= GameManager.SCROLL_SPEED * delta

func _ready():
	GameManager.on_player_died.connect(game_over)

func game_over():
	set_process(false)
