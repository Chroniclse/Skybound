extends CanvasLayer

func _ready() -> void:
	$Control/VBoxContainer/BackButton.pressed.connect(_on_back_button_pressed)
	_display_controls()

func _display_controls() -> void:
	var controls_text = $Control/VBoxContainer/ControlsText
	
	var text = "CONTROLS\n\n"
	text += "Movement:\n"
	text += "  W / Up Arrow - Move Up\n"
	text += "  S / Down Arrow - Move Down\n"
	text += "  A / Left Arrow - Move Left\n"
	text += "  D / Right Arrow - Move Right\n\n"
	text += "Actions:\n"
	text += "  Z / Left Mouse Button - Attack\n"
	
	controls_text.text = text

func _on_back_button_pressed() -> void:
	# Return to previous screen (Main Menu or Lobby)
	if LevelManager.current_scene_type == "Lobby":
		LevelManager.return_to_lobby()
	else:
		get_tree().change_scene_to_file("res://GUI/MainMenu/main_menu.tscn")
