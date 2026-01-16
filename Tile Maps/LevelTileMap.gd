class_name TileLevelMap extends TileMap



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not LevelManager:
		return
	if LevelManager.current_scene_type == "Lobby" or LevelManager.current_scene_type == "LevelSelection" or LevelManager.current_scene_type == "MainMenu":
		return
	var existing_bounds = LevelManager.current_tilemap_bounds
	if existing_bounds != null and existing_bounds.size() > 0:
		return
	LevelManager.ChangeTileMapBounds(getTileMapBounds())
	pass # Replace with function body.

func getTileMapBounds () -> Array[Vector2]:
	var bounds : Array[Vector2] = []
	var used_rect = get_used_rect()
	if not used_rect.has_area():
		return bounds
	if tile_set == null:
		return bounds
	
	var tile_size = tile_set.tile_size
	var local_min = map_to_local(used_rect.position)
	var local_max = map_to_local(used_rect.end - Vector2i(1, 1)) + Vector2(tile_size)
	
	bounds.append(to_global(local_min))
	bounds.append(to_global(local_max))
	return bounds
