class_name Collectable2D
extends Area2D
## A simple component to make anything a collectable.

#region VARIABLES
## The identifier for this collectable.
@export var identifier: String = ''
#endregion

#region SIGNALS
## Emitted when the collectable has been collected.
signal collected
#endregion

#region FUNCTIONS
## To be called by a collector when this collectable is to be collected.
func collect() -> void:
	collected.emit()
#endregion
