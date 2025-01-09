extends Node

#region ENUMS
enum Game {
	OVER,
	NEW,
	PLAYING,
}
enum Speed {
	MIN = 10,
	MAX = 500,
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
#endregion

#region SIGNALS
signal game_changed(game:int)
signal speed_changed(speed:float)
#endregion
