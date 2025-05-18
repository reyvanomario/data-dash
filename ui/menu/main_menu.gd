extends CanvasLayer


var start_selected_texture: Texture2D = preload("res://assets/compfest/Menus/Main-start (1).png")
var exit_selected_texture: Texture2D = preload("res://assets/compfest/Menus/Main-exit (1).png")
var credit_selected_texture: Texture2D = preload("res://assets/compfest/Menus/Main-credits (1).png")

@onready var menu_option_texture: TextureRect = $MenuOptionTexture
var current_selection: int = 0
const OPTION_COUNT = 3

var _input_locked := false



func _ready() -> void:
	update_menu_display()
	

func _input(event):
	if _input_locked:
		return
		
		
	if event.is_action_pressed("ui_down"):
		current_selection = (current_selection + 1) % OPTION_COUNT
		update_menu_display()

	elif event.is_action_pressed("ui_up"):
		current_selection = (current_selection + OPTION_COUNT - 1) % OPTION_COUNT
		update_menu_display()
		
		
	if event.is_action_pressed("ui_accept"):
		_input_locked = true
		
		$RandomStreamPlayerComponent.play_random()
		await $RandomStreamPlayerComponent.finished
	
		
		await _on_accept()
		

	

func on_credit_pressed():
	pass
	

func update_menu_display():
	match current_selection:
		0:
			menu_option_texture.texture = start_selected_texture
		1:
			menu_option_texture.texture = exit_selected_texture
		2:
			menu_option_texture.texture = credit_selected_texture


func handle_selection():
	if not is_inside_tree():
		return
	
	print(GameManager.game)
		
	match current_selection:
		0:
			ScreenTransition.transition()
			await ScreenTransition.transitioned_halfway
			
			if is_inside_tree():
				GameManager.game = GameManager.Game.NEW
				get_tree().change_scene_to_file("res://stages/main/main.tscn")

		1:
			if is_inside_tree():
				get_tree().quit()
		
		2:
			if is_inside_tree():
				print("credit")
			
			
func _on_accept() -> void:
	handle_selection()
	_input_locked = false
			


	
	
