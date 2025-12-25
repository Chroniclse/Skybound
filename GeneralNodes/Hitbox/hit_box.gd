class_name HitBox extends Area2D

signal Damaged(hurt_box : HurtBox)

func TakeDamage(hurt_box : HurtBox) -> void:
	Damaged.emit(hurt_box)



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
