extends Node

#SIGNAL PAS PLAYER MATI
signal on_player_died

#SPEED ENEMY
const SCROLL_SPEED: float = 650.0
var game_pause = false

#MENGGANTI SCENE
const game_scene: PackedScene = preload("res://Scenes/game.tscn")
func load_game_scene():
	get_tree().change_scene_to_packed(game_scene)

const main_scene: PackedScene = preload("res://Scenes/main.tscn")
func load_main_scene():
	get_tree().change_scene_to_packed(main_scene)
