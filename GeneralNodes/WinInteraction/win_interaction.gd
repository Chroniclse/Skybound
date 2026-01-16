extends Area2D

signal player_entered_range
signal player_exited_range

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Monitor bodies to detect player
	monitoring = true
	monitorable = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered_range.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_exited_range.emit()
