class_name Destructable2D
extends Area2D
## A simple component to make anything a destructable.

#region VARIABLES
## Amount of health before being being destroyed.
@export_range(1, 10) var health: int = 1 :
	set(h):
		health = h if h >= 0 else 0
		if health == 0:
			destroyed.emit()
#endregion

#region SIGNALS
## Emitted when destroyed.
signal destroyed
#endregion

#region FUNCTIONS
## Called by a destructor to make this destructable take damage.
func destruct(amount: int = health) -> void:
	health -= amount
#endregion
