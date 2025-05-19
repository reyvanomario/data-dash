extends Control


func _ready() -> void:
	GameManager.game_changed.connect(on_game_changed)
	
	

func on_game_changed(game: int):
	if game == GameManager.Game.NEW:
		visible = true
	
	elif game == GameManager.Game.PLAYING:
		visible = false
		
		MusicPlayer.play_game_music()
	
