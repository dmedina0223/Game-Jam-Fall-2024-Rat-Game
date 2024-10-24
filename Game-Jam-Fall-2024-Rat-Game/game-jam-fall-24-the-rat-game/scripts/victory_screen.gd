extends Control

func _on_pressed() -> void:
	AudioControl._stop_music()
	AudioControl._play_main_music()
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
