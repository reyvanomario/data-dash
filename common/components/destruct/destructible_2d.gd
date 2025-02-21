class_name Destructable2D
extends Area2D

#region VARIABLES
@export_range(1, 10) var health: int = 1 :
	set(h):
		health = h if h >= 0 else 0
		if health == 0:
			destroyed.emit()
#endregion

#region SIGNALS
signal destroyed
#endregion

#region FUNCTIONS
func destruct(amount: int = health) -> void:
	health -= amount
#endregion
