extends CanvasLayer


var start_selected_texture: Texture2D = preload("res://assets/compfest/Menus/main_menu_start_selected.PNG")
var credit_selected_texture: Texture2D = preload("res://assets/compfest/Menus/main_menu_credits_selected.PNG")

@onready var menu_option_texture: TextureRect = $MenuOptionTexture
@onready var credit_texture: TextureRect = $CreditTexture


@onready var line_edit: LineEdit = $%InputCodeLineEdit
@onready var response_label: Label = $%ResponseLabel
@onready var input_code_container: Control = $InputCodeContainer

var current_selection: int = 0


var _input_locked := false

var credit_opened := false
var input_code_opened := false

var _is_processing_request: bool = false



func _ready() -> void:
	GlobalGameCodeVerifier.request_failed.connect(on_request_failed)
	GlobalGameCodeVerifier.game_code_succeed.connect(on_game_code_succeed)
	GlobalGameCodeVerifier.game_code_failed.connect(on_game_code_failed)
	
	line_edit.text_submitted.connect(on_line_edit_text_submitted)
	#update_menu_display()
	

func _input(event):
	if _input_locked:
		return
		
	if credit_opened:
		if event.is_action_pressed("ui_cancel"):
			$RandomStreamPlayerComponent.play_random()
			await $RandomStreamPlayerComponent.finished
			credit_texture.visible = false
			credit_opened = false
		
	
	if input_code_opened:
		if event.is_action_pressed("ui_cancel"):
			$RandomStreamPlayerComponent.play_random()
			await $RandomStreamPlayerComponent.finished
			input_code_container.visible = false
			input_code_opened = false
			
		
		
	if event.is_action_pressed("ui_down") || event.is_action_pressed("ui_up"):
		current_selection = 1 - current_selection  
		
		update_menu_display()
		
		
	if event.is_action_pressed("ui_accept") and !credit_opened and !input_code_opened:
		_input_locked = true
		
		$RandomStreamPlayerComponent.play_random()
		await $RandomStreamPlayerComponent.finished
	
		
		await _on_accept()
		

	
	

func update_menu_display():
	match current_selection:
		0:
			menu_option_texture.texture = start_selected_texture
		1:
			menu_option_texture.texture = credit_selected_texture
	


func handle_selection():
	if not is_inside_tree():
		return
	
		
	match current_selection:
		0:
			if is_inside_tree():
				input_code_container.visible = true
				input_code_opened = true
			
			
			#if is_inside_tree():
				#ScreenTransition.transition()
				#await ScreenTransition.transitioned_halfway
				#
				#GameManager.game = GameManager.Game.NEW
				#get_tree().change_scene_to_file("res://stages/main/main.tscn")

		1:
			if is_inside_tree():
				credit_texture.visible = true
				credit_opened = true
			
			
func _on_accept() -> void:
	handle_selection()
	_input_locked = false
	

func on_line_edit_text_submitted(game_code: String):
	if _is_processing_request:
		return
		
	_is_processing_request = true
	line_edit.editable = false
	line_edit.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		
	$RandomStreamPlayerComponent.play_random()
	await $RandomStreamPlayerComponent.finished

	
	#GlobalGameCodeVerifier.verify_game_code(game_code)
	
	if is_inside_tree():
		ScreenTransition.transition()
		await ScreenTransition.transitioned_halfway
		
		GameManager.game = GameManager.Game.NEW
		get_tree().change_scene_to_file("res://stages/main/main.tscn")
	#

			
			
func on_request_failed(error_message: String):
	_is_processing_request = false
	line_edit.editable = true
	line_edit.mouse_filter = Control.MOUSE_FILTER_STOP
	
	response_label.text = error_message
	response_label.add_theme_color_override("font_color", Color.RED)
	response_label.visible = true	
	
		

func on_game_code_succeed(response_messages: String):
	_is_processing_request = false
	line_edit.editable = true
	line_edit.mouse_filter = Control.MOUSE_FILTER_STOP
	
	response_label.visible = false
	
	if is_inside_tree():
		ScreenTransition.transition()
		await ScreenTransition.transitioned_halfway
		
		GameManager.game = GameManager.Game.NEW
		get_tree().change_scene_to_file("res://stages/main/main.tscn")
	
	
	
	
	

func on_game_code_failed(error_message: String):
	_is_processing_request = false
	line_edit.editable = true
	line_edit.mouse_filter = Control.MOUSE_FILTER_STOP
	
	response_label.text = error_message
	response_label.add_theme_color_override("font_color", Color.RED)
	response_label.visible = true
	
	


	
	
