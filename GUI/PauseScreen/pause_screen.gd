extends CanvasLayer

func _ready() -> void:
	$Control/VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$Control/VBoxContainer/RetryButton.pressed.connect(_on_retry_pressed)
	$Control/VBoxContainer/LobbyButton.pressed.connect(_on_lobby_pressed)
	
	# Make sure the pause screen works while game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func _reset_player_lives() -> void:
	# Reset player health to max when leaving the pause screen (for retry/lobby)
	if PlayerManager.player:
		PlayerManager.player.update_hp(99)  # Sets hp back to max_hp

func _on_resume_pressed() -> void:
	# Resume by unpausing and removing the pause screen
	get_tree().paused = false
	LevelManager.pause_screen_instance = null
	queue_free()

func _on_retry_pressed() -> void:
	_reset_player_lives()
	get_tree().paused = false
	LevelManager.pause_screen_instance = null
	queue_free()
	LevelManager.reload_current_level()

func _on_lobby_pressed() -> void:
	_reset_player_lives()
	get_tree().paused = false
	LevelManager.pause_screen_instance = null
	queue_free()
	LevelManager.return_to_lobby()
