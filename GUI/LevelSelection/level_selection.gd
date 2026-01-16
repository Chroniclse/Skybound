extends CanvasLayer

var levels: Array[Dictionary] = [
	{
		"name": "Playground",
		"path": "res://playground.tscn",
		"description": "Grass field with slimes - Test area!"
	},
	{
		"name": "Level 1",
		"path": "res://Levels/Level1/level1.tscn",
		"description": "Cyberpunk Escape - Make it to the end"
	},
	{
		"name": "Level 2",
		"path": "res://Levels/Level2/level2.tscn",
		"description": "Cyberpunk Arena - Survive..."
	}
]

func _ready() -> void:
	$Control/VBoxContainer/BackButton.pressed.connect(_on_back_button_pressed)
	_create_level_buttons()

func _create_level_buttons() -> void:
	var button_container = $Control/VBoxContainer/LevelContainer
	
	for level in levels:
		var button = Button.new()
		button.text = level.name + "\n" + level.description
		button.custom_minimum_size = Vector2(300, 80)
		button.pressed.connect(_on_level_button_pressed.bind(level.path))
		button_container.add_child(button)

func _on_level_button_pressed(level_path: String) -> void:
	LevelManager.load_gameplay_level(level_path)

func _on_back_button_pressed() -> void:
	LevelManager.return_to_lobby()
