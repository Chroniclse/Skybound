extends CanvasLayer

func _ready() -> void:
	# Wait a frame to ensure all nodes are ready
	await get_tree().process_frame
	
	# Connect buttons with null checks
	var retry_button = $Control/VBoxContainer.get_node_or_null("RetryButton")
	var lobby_button = $Control/VBoxContainer.get_node_or_null("ReturnToLobbyButton")
	
	if retry_button:
		retry_button.pressed.connect(_on_retry_pressed)
	if lobby_button:
		lobby_button.pressed.connect(_on_return_to_lobby_pressed)

func _reset_player_lives() -> void:
	# Reset player health to max when leaving the lose screen
	if PlayerManager.player:
		PlayerManager.player.update_hp(99)  # Sets hp back to max_hp

func _on_retry_pressed() -> void:
	_reset_player_lives()
	LevelManager.reload_current_level()

func _on_return_to_lobby_pressed() -> void:
	_reset_player_lives()
	LevelManager.return_to_lobby()
