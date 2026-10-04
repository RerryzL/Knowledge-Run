extends Control

@onready var scorelabel = $MarginContainer/Scorelabel
@onready var hi_scorelabel = $"MarginContainer/Hi-Scorelabel"

static var timer_count = 0
static var high_score = 0

var time_elapsed = 0

func _process(delta):
	time_elapsed += delta
	
func _ready():
	scorelabel.text = str("%.1f" % timer_count)
	$gamesound.play()
	update_high_score()
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		GameManager.load_game_scene()

func update_high_score() -> void:
	if timer_count > high_score:
		high_score = float("%.1f" % timer_count)
		hi_scorelabel.text = "%.1f" % high_score
	else:
		hi_scorelabel.text = "%.1f" % high_score
