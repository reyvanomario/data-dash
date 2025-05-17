class_name GameBackground
extends ParallaxBackground


var scrolling:bool = false :
	set(s):
		if s == scrolling: return
		scrolling = s


func _ready() -> void:
	GameManager.game_changed.connect(on_game_changed)

func _process(delta):
	if scrolling:
		scroll_base_offset.x += -GameManager.speed * delta



func on_game_changed(game: int):
	if game == GameManager.Game.OVER:
		scrolling = false
	elif game == GameManager.Game.NEW:
		scrolling = false
		scroll_base_offset = Vector2.ZERO
	elif game == GameManager.Game.PLAYING:
		scrolling = true
