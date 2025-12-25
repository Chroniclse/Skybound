class_name State extends Node

static var player: Player
static var state_machine : PlayerStateMachine
func _ready() -> void:
	pass # Replace with function body.

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func init() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
	return null
func Physics(_delta: float) -> State:
	return null

func HandleInput(_event : InputEvent) -> State:
	return null
