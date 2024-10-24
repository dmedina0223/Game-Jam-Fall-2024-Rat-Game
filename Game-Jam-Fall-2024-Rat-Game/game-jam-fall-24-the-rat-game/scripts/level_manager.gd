class_name LevelManager
extends Node

const CAMERA_HEIGHT = 768
const CAMERA_WIDTH = 1024

@onready var camera: Camera2D = $Camera2D
@onready var player: Player = %Player
@onready var jingle = preload("res://assets/audio/RatGameVictoryJingleV2.mp3")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioControl.stop()
	AudioControl._play_level_music_1()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.global_position.y <= camera.global_position.y - CAMERA_HEIGHT / 2:
		print_debug("Up")
		camera.global_position.y -= CAMERA_HEIGHT
	else:
		if player.global_position.y >= camera.global_position.y + CAMERA_HEIGHT / 2:
			print_debug("Down")
			camera.global_position.y += CAMERA_HEIGHT


func _on_level_2_transition_area_entered(area: Area2D) -> void:
	if AudioControl.track == 1:
		AudioControl.stop()
		AudioControl._play_level_music_2()


func _on_level_3_transition_area_entered(area: Area2D) -> void:
	if AudioControl.track == 2:
		AudioControl.stop()
		AudioControl._play_level_music_3()


func _on_win_area_area_entered(area: Area2D) -> void:
	AudioControl._stop_music()
	AudioControl._play_fx(jingle, -6.0)
	get_tree().change_scene_to_file("res://scenes/victory_screen.tscn")
	print_debug("WIN")
	pass # Replace with function body.
