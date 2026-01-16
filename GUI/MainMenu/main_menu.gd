extends CanvasLayer

func _ready() -> void:
	# Connect button signals
	var start_button = $Control/VBoxContainer/StartButton
	var controls_button = $Control/VBoxContainer/ControlsButton
	var quit_button = $Control/VBoxContainer/QuitButton
	
	if start_button:
		start_button.pressed.connect(_on_start_button_pressed)
	if controls_button:
		controls_button.pressed.connect(_on_controls_button_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed() -> void:
	if LevelManager:
		LevelManager.load_lobby()
	else:
		print("ERROR: LevelManager not found!")

func _on_controls_button_pressed() -> void:
	var controls_path = "res://GUI/ControlsScreen/controls_screen.tscn"
	if ResourceLoader.exists(controls_path):
		get_tree().change_scene_to_file(controls_path)
	else:
		print("ERROR: Controls screen not found at: ", controls_path)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
