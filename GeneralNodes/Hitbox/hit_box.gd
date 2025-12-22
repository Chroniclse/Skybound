class_name hitbox extends Area2D

signal Damaged(damage: int)

func TakeDamage(damage : int) -> void:
	print("The player took " , damage, " damage")
	Damaged.emit(damage)



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
