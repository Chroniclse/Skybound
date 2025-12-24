class_name TileLevelMap extends TileMap



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.ChangeTileMapBounds(getTileMapBounds())
	pass # Replace with function body.

func getTileMapBounds () -> Array[Vector2]:
	var bounds : Array[Vector2] = []
	
	bounds.append(
		Vector2(get_used_rect().position * rendering_quadrant_size)	
	)
	bounds.append(
		Vector2(get_used_rect().end * rendering_quadrant_size)	
	)
	
	
	return bounds
