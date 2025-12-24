class_name HitBox extends Area2D

signal Damaged(damage: int)

func TakeDamage(damage : int) -> void:
	print(damage, " damage taken")
	Damaged.emit(damage)



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
