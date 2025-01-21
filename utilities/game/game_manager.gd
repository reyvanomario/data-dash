class_name GameManagerGlobal
extends Node
## The global game manager.
##
## A simple global manager keeping track of game essentials.[br]
## This should be added as a global script named [param GameManager].[br]
## It's then reachable by all other components under that name.

#region ENUMS
## All possible game states.
enum Game {
	OVER,
	NEW,
	PLAYING,
}
## All range stages for the base speed.
enum Speed {
	MIN = 400,
	MAX = 2000,
}
#endregion

#region CONSTANST
## How much the base speed increases every frame * delta
const SPEED_AMPLIFIER:int = 10
#endregion

#region VARIABLES
## The current game state.[br]
## Can only be set to one of the [enum Game] enum values.[br]
## When changed, the [signal game_changed] signal will be emitted together with the new value.[br]
## If [enum Game][param .NEW]: [member speed] is set to [enum Speed][param .MIN].
var game:int = Game.NEW :
	set(g):
		if g == game:
			return
		
		assert(g in Game.values(), '%s is not a valid Game state.' % str(g))
		
		game = g
		game_changed.emit(game)
		
		if game == Game.NEW:
			speed = Speed.MIN
## The current game state.[br]
## Can only be set between the lowest and highest values of the [enum Speed] enum values.[br]
## When changed, the [signal speed_changed] signal will be emitted together with the new value.[br]
var speed:float = Speed.MIN :
	set(s):
		if s < Speed.MIN or s > Speed.MAX:
			return
		
		speed = s
		speed_changed.emit(speed)
#endregion

#region SIGNALS
## Emitted when [member game] changes, together with the new value.
signal game_changed(game:int)
## Emitted when [member speed] changes, together with the new value.
signal speed_changed(speed:float)
#endregion

#region FUNCTIONS
## Starting and resetting the game is handled here.
func _unhandled_input(event: InputEvent) -> void:
	if game == Game.NEW and event.is_action_pressed('fly'):
		game = Game.PLAYING
	if game == Game.PLAYING and event.is_action_pressed("ui_cancel"):
		game = Game.NEW

## Increasing the game speed is handled here.
func _process(delta: float) -> void:
	if game == Game.PLAYING:
		speed += SPEED_AMPLIFIER * delta
#endregion
