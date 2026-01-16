extends Node


var current_tilemap_bounds : Array[Vector2]
var current_level_path: String = ""
var current_scene_type: String = "MainMenu"  # MainMenu, Lobby, LevelSelection, GameplayLevel

signal TileMapBoundsChanged (bounds : Array[Vector2])
signal level_completed
signal level_failed


func ChangeTileMapBounds (bounds : Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	print("LevelManager: Emitting TileMapBoundsChanged signal with bounds: ", bounds)
	TileMapBoundsChanged.emit(bounds)
	print("LevelManager: Signal emitted, connections: ", TileMapBoundsChanged.get_connections().size())


func load_lobby() -> void:
	current_scene_type = "Lobby"
	get_tree().change_scene_to_file("res://Levels/Lobby.tscn")


func load_level_selection() -> void:
	current_scene_type = "LevelSelection"
	get_tree().change_scene_to_file("res://GUI/LevelSelection/level_selection.tscn")


func load_gameplay_level(level_path: String) -> void:
	current_level_path = level_path
	current_scene_type = "GameplayLevel"
	get_tree().change_scene_to_file(level_path)


func return_to_lobby() -> void:
	# Reset player health to max when returning to lobby
	if PlayerManager.player:
		PlayerManager.player.update_hp(99)  # Sets hp back to max_hp
	load_lobby()


func reload_current_level() -> void:
	if current_level_path != "":
		load_gameplay_level(current_level_path)


func _ready() -> void:
	level_completed.connect(_on_level_completed)
	level_failed.connect(_on_level_failed)

var pause_screen_instance: Node = null

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			# If in a gameplay level, show pause screen as overlay
			if current_scene_type == "GameplayLevel":
				if pause_screen_instance == null:
					# Pause the game and show pause screen overlay
					get_tree().paused = true
					var pause_screen = load("res://GUI/PauseScreen/pause_screen.tscn").instantiate()
					# Set process mode so pause screen works while game is paused
					pause_screen.process_mode = Node.PROCESS_MODE_ALWAYS
					get_tree().root.add_child(pause_screen)
					pause_screen_instance = pause_screen
				else:
					# Already paused, unpause when ESC is pressed again
					get_tree().paused = false
					if is_instance_valid(pause_screen_instance):
						pause_screen_instance.queue_free()
					pause_screen_instance = null
			else:
				# Otherwise go to main menu
				load_main_menu()

func load_main_menu() -> void:
	current_scene_type = "MainMenu"
	get_tree().change_scene_to_file("res://GUI/MainMenu/main_menu.tscn")


func _on_level_completed() -> void:
	get_tree().change_scene_to_file("res://GUI/WinScreen/win_screen.tscn")


func _on_level_failed() -> void:
	get_tree().change_scene_to_file("res://GUI/LoseScreen/lose_screen.tscn")
