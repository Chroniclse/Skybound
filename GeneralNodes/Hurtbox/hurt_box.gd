class_name hurt_box extends Area2D

@export var damage : int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(AreaEntered)

func AreaEntered(a : Area2D)-> void:
	if a is HitBox:
		a.TakeDamage(damage)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
