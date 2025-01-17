extends Node

#region ENUMS
enum Game {
	OVER,
	NEW,
	PLAYING,
}
enum Speed {
	MIN = 400,
	MAX = 2000,
}
#endregion

#region VARIABLES
var game:int = Game.NEW :
	set(g):
		if g == game:
			return
		
		assert(g in Game.values(), '%s is not a valid Game state.' % str(g))
		
		game = g
		game_changed.emit(game)
var speed:float = Speed.MIN :
	set(s):
		if s < Speed.MIN or s > Speed.MAX:
			return
		
		speed = s
		speed_changed.emit(speed)
#endregion

#region SIGNALS
signal game_changed(game:int)
signal speed_changed(speed:float)
#endregion

func _unhandled_input(event: InputEvent) -> void:
	if game == Game.NEW and event.is_action_pressed('fly'):
		game = Game.PLAYING
	if game == Game.PLAYING and event.is_action_pressed("ui_cancel"):
		game = Game.NEW
