class_name Collectable2D
extends Area2D

#region VARIABLES
@export var identifier: String = ''
#endregion

#region SIGNALS
signal collected()
#endregion

#region FUNCTIONS
func collect() -> void:
	collected.emit()
#endregion
