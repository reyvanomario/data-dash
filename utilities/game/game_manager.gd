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

## All exact scrolling speed values/steps.
## The actual speed will increment from [param START] up to [param MAX] by [param STEP] * delta each frame.
## When the game resets, the speed is set to [param RESET].
enum Speed {
	RESET = 0,
	STEP = 10,
	START = 400,
	MAX = 2000,
}
#endregion

#region VARIABLES
## The current game state.[br]
## Can only be set to one of the [enum Game] enum values.[br]
## When changed, the [signal game_changed] signal will be emitted together with the new value.[br]
## If [enum Game][param .OVER] or [enum Game][param .NEW]: [member speed] is set to [enum Speed][param .RESET].
## If [enum Game][param .PLAYING]: [member speed] is set to [enum Speed][param .START].
var game:int = Game.NEW :
	set(g):
		if g == game:
			return
		
		assert(g in Game.values(), '%s is not a valid Game state.' % str(g))
		
		game = g
		game_changed.emit(game)
		
		match game:
			Game.OVER or Game.NEW:
				speed = Speed.RESET
			Game.PLAYING:
				speed = Speed.START
## The current game speed.[br]
## It can't be set higher than [enum Speed][param .MAX].[br]
var speed:float = Speed.RESET :
	set(s):
		if s > Speed.MAX:
			return
		speed = s
#endregion

#region SIGNALS
## Emitted when [member game] changes, together with the new value.
signal game_changed(game:int)
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
	if Game.PLAYING:
		speed += Speed.STEP * delta
#endregion
