extends Area2D

signal player_reached_win_condition

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_reached_win_condition.emit()
		LevelManager.level_completed.emit()
