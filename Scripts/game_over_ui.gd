extends Panel

@onready var presslabel: Label = $presslabel
@onready var timer: Timer = $Timer

func _ready() -> void:
	GameManager.on_player_died.connect(show_game_over)

func show_game_over() -> void:
	timer.start()
	self.show() #menunjukkan game_over_UI. sama aja kayak $".".show() maupun show()

func _on_timer_timeout():
	presslabel.show() #presslabel.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and presslabel.visible == true:
		GameManager.load_main_scene()
