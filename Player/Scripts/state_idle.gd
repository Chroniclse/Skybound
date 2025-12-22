class_name State_Idle extends State
@onready var attack : State = $ "../Attack"
@onready var walk : State = $ "../Walk"

func Enter() -> void:
	player.updateAnimation("idle")
	pass

func Exit() -> void:
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	
func Physics(_delta: float) -> State:
	return null

func HandleInput(_event : InputEvent) -> State:
	
	if _event.is_action_pressed("Attack"):
		return attack
	
	return null
