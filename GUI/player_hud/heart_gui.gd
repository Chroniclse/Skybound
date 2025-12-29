class_name heartGUI extends Control

@onready var sprite = $Sprite2D


var value : int = 2 :
	set (_value):
		value = _value
		update_sprite()

func update_sprite() -> void:
	sprite.region_rect.position.x = value * 9 
	sprite.modulate = Color.WHITE 
	
