extends HBoxContainer

@onready var life_count_label = $LifeLabel
	
	
func incrementLifes(current_lifes: int):
	current_lifes = current_lifes + 1
	
	life_count_label.text = "x " + str(current_lifes)	


func decrementLifes(current_lifes: int):
	current_lifes = current_lifes - 1
	
	life_count_label.text = "x " + str(current_lifes)

	$AnimationPlayer.play("decrement_life")
	var t = get_tree().create_timer(3)
	# tunggu sampai timeout
	await t.timeout
	
	$AnimationPlayer.stop()
