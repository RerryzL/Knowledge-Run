extends Node2D
var enemy_scene = preload ("res://Scenes/enemy.tscn")
var book_scene = preload("res://Scenes/book.tscn")
var main_scene = load("res://Scripts/main.gd").new()

@onready var top_post: Marker2D = $TopPost
@onready var bot_post: Marker2D = $BotPost
@onready var spawn_timer: Timer = $SpawnTimer
@onready var score_label: Label = $HUD/ScoreLabel
@onready var decor_timer = $decorTimer

var timer_count : float = 0.0

func _process(delta: float) -> void:
	timer_count += delta
	score_label.text = "%.1f" % (timer_count * 10)

func _ready() -> void:
	GameManager.game_pause = false
	$quiz.visible = false
	$titlesound.play()
	GameManager.on_player_died.connect(game_over)

func game_over() -> void:
	$titlesound.stop()
	spawn_timer.stop()
	decor_timer.stop()
	main_scene.timer_count = timer_count
	set_process(false) 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func add_enemy() -> void:
	var enemy_instance = enemy_scene.instantiate()
	add_child(enemy_instance)
	if randf() >= 0.5:
		enemy_instance.position = top_post.position
	else:
		enemy_instance.position = bot_post.position
func add_book() -> void:
	var book_instance = book_scene.instantiate()
	add_child(book_instance)
	book_instance.position.x = 1550
	book_instance.position.y = 586.0
	book_instance.on_picked_up.connect(question_session)


var current_question = null
var current_answer = null

func question_session():
	current_question = generate_single_soal()
	current_answer = current_question["jawaban"]
	$decorTimer.stop()
	$SpawnTimer.stop()
	$quiz.visible = true
	$quiz/Label.text = current_question["teks"]
	$quiz/button1.text = str(current_question["opsi1"])
	$quiz/button2.text = str(current_question["opsi2"])
	$quiz/button3.text = str(current_question["opsi3"])
	$quiz/button4.text = str(current_question["opsi4"])

	GameManager.game_pause = true
	set_process(false)

func _on_timer_timeout() -> void:
	add_enemy()

func _on_decor_timer_timeout():
	add_book()
	decor_timer.wait_time = randf_range(1, 10)


func _on_button_1_pressed() -> void:
	set_process(true)
	GameManager.game_pause = false
	check_answer(1)
func _on_button_2_pressed() -> void:
	set_process(true)
	GameManager.game_pause = false
	check_answer(2)
func _on_button_3_pressed() -> void:
	set_process(true)
	GameManager.game_pause = false
	check_answer(3)
func _on_button_4_pressed() -> void:
	set_process(true)
	GameManager.game_pause = false
	check_answer(4)

func check_answer(index):
	if current_question["opsi" + str(index)] == current_answer:
		timer_count += 10
	else:
		timer_count -= 5
	$quiz.visible = false
	$decorTimer.start()
	$SpawnTimer.start()
func generate_single_soal():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var a = rng.randi_range(1, 20)
	var b = rng.randi_range(1, 20)
	var soal = {}

	var tipe = rng.randi_range(0, 4)
	var jawaban = 0
	match tipe:
		0:
			soal["jenis"] = "penjumlahan"
			soal["teks"] = str(a) + " + " + str(b)
			jawaban = a + b
		1:
			soal["jenis"] = "pengurangan"
			var max_val = max(a, b)
			var min_val = min(a, b)
			soal["teks"] = str(max_val) + " - " + str(min_val)
			jawaban = max_val - min_val
		2:
			soal["jenis"] = "perkalian"
			soal["teks"] = str(a) + " × " + str(b)
			jawaban = a * b
		3:
			soal["jenis"] = "pembagian"
			var hasil = rng.randi_range(1, 10)
			var pembagi = rng.randi_range(1, 10)
			var pembilang = hasil * pembagi
			soal["teks"] = str(pembilang) + " ÷ " + str(pembagi)
			jawaban = hasil
		_:
			soal["jenis"] = "campuran"
			var x = rng.randi_range(1, 10)
			var y = rng.randi_range(1, 10)
			var z = rng.randi_range(1, 10)
			soal["teks"] = str(x) + " + " + str(y) + " × " + str(z)
			jawaban = x + y * z

	soal["jawaban"] = jawaban

	# Membuat 4 opsi, salah satunya adalah jawaban benar
	var opsi1 = jawaban
	var opsi2 = jawaban + rng.randi_range(1, 5)
	var opsi3 = jawaban - rng.randi_range(1, 5)
	var opsi4 = jawaban + rng.randi_range(6, 10)

	# Acak posisi jawaban
	var opsi_semua = [opsi1, opsi2, opsi3, opsi4]
	opsi_semua.shuffle()
	soal["opsi1"] = opsi_semua[0]
	soal["opsi2"] = opsi_semua[1]
	soal["opsi3"] = opsi_semua[2]
	soal["opsi4"] = opsi_semua[3]

	return soal
