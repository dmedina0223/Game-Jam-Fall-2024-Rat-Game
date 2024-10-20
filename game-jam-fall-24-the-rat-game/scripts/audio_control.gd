extends AudioStreamPlayer

@onready var level_music = preload("res://assets/audio/RatGameBasementThemeV3.mp3")


func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()

func _play_level_music():
	_play_music(level_music)

func _play_fx(sound: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = sound
	fx_player.volume_db = volume
	fx_player.name = "FX_PLAYER"
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()
