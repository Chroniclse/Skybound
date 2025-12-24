class_name Plant extends Node2D


func _ready() -> void:
	$HitBox.Damaged.connect(TakeDamage)
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func TakeDamage(_damage : int) -> void:
	queue_free()
	pass
