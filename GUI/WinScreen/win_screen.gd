extends CanvasLayer

func _ready() -> void:
	# Wait a frame to ensure all nodes are ready
	await get_tree().process_frame
	
	# Connect Return to Lobby button
	var lobby_button = $Control/VBoxContainer.get_node_or_null("ReturnToLobbyButton")
	if lobby_button:
		lobby_button.pressed.connect(_on_return_to_lobby_pressed)
	
	# For Level 1, hide Level Select button and only show Return to Lobby
	if LevelManager.current_level_path.contains("Level1"):
		var level_select_button = $Control/VBoxContainer.get_node_or_null("LevelSelectButton")
		if level_select_button:
			level_select_button.visible = false
		# Automatically return to lobby after 2 seconds (but button is still available)
		await get_tree().create_timer(2.0).timeout
		LevelManager.return_to_lobby()
	else:
		# For other levels, show Level Select button
		var level_select_button = $Control/VBoxContainer.get_node_or_null("LevelSelectButton")
		if level_select_button:
			level_select_button.pressed.connect(_on_level_select_pressed)

func _on_level_select_pressed() -> void:
	LevelManager.load_level_selection()

func _on_return_to_lobby_pressed() -> void:
	# Lives will be reset by LevelManager.return_to_lobby()
	LevelManager.return_to_lobby()
