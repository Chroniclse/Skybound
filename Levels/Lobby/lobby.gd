extends Node2D

@onready var player_spawn: Node2D = $PlayerSpawn
@onready var tv_interaction: Area2D = $TVInteraction
const LOBBY_SCALE = 1.2

var player_near_tv: bool = false

func _ready() -> void:
	# Position player at spawn point - wait a frame to ensure player is ready
	await get_tree().process_frame
	_position_player_at_spawn()
	_scale_player_for_lobby()
	
	# Connect TV interaction signals
	if tv_interaction:
		tv_interaction.player_entered_range.connect(_on_player_entered_tv_range)
		tv_interaction.player_exited_range.connect(_on_player_exited_tv_range)
	
	# Wait for all tilemaps to initialize, then set camera bounds
	await get_tree().process_frame
	_set_lobby_camera_bounds()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and player_near_tv:
		LevelManager.load_level_selection()
		var viewport = get_viewport()
		if viewport:
			viewport.set_input_as_handled()

func _on_player_entered_tv_range() -> void:
	player_near_tv = true
	# Show hint to player
	if PlayerHud:
		PlayerHud.show_hint("Press X to open level selection")

func _on_player_exited_tv_range() -> void:
	player_near_tv = false
	# Hide hint
	if PlayerHud:
		PlayerHud.hide_hint()

func _position_player_at_spawn() -> void:
	if player_spawn:
		# Ensure spawn is within apartment bounds
		var spawn_pos = _ensure_spawn_in_bounds(player_spawn.global_position)
		
		if PlayerManager.player:
			PlayerManager.player.global_position = spawn_pos
		else:
			# If player doesn't exist yet, wait a bit more
			await get_tree().create_timer(0.1).timeout
			if PlayerManager.player:
				PlayerManager.player.global_position = spawn_pos

func _scale_player_for_lobby() -> void:
	if PlayerManager.player:
		PlayerManager.player.scale = Vector2(LOBBY_SCALE, LOBBY_SCALE)
	else:
		# If player doesn't exist yet, wait a bit more
		await get_tree().create_timer(0.1).timeout
		if PlayerManager.player:
			PlayerManager.player.scale = Vector2(LOBBY_SCALE, LOBBY_SCALE)

func _ensure_spawn_in_bounds(spawn_pos: Vector2) -> Vector2:
	# Find the Apartment tilemap specifically
	var apartment_tilemap: TileMap = null
	for child in get_children():
		if child is TileMap and child.name == "Apartment":
			apartment_tilemap = child
			break
	
	if apartment_tilemap and apartment_tilemap.has_method("getTileMapBounds"):
		var bounds = apartment_tilemap.getTileMapBounds()
		if bounds.size() >= 2:
			var tilemap_pos = apartment_tilemap.global_position
			var world_min = bounds[0] + tilemap_pos
			var world_max = bounds[1] + tilemap_pos
			
			# Clamp spawn position to apartment bounds (with some padding)
			var padding = 16.0  # Small padding from edges
			spawn_pos.x = clamp(spawn_pos.x, world_min.x + padding, world_max.x - padding)
			spawn_pos.y = clamp(spawn_pos.y, world_min.y + padding, world_max.y - padding)
	
	return spawn_pos

func _set_lobby_camera_bounds() -> void:
	# Find all tilemaps in the lobby and calculate combined bounds
	var all_tilemaps = []
	var apartment_tilemap: TileMap = null
	
	for child in get_children():
		if child is TileMap:
			all_tilemaps.append(child)
			if child.name == "Apartment":
				apartment_tilemap = child
	
	if all_tilemaps.is_empty():
		return
	
	# Calculate the combined bounds of all tilemaps
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF
	
	# First, get bounds from all tilemaps
	for tilemap in all_tilemaps:
		if tilemap.has_method("getTileMapBounds"):
			var bounds = tilemap.getTileMapBounds()
			if bounds.size() >= 2:
				# bounds[0] is top-left, bounds[1] is bottom-right (already in world coordinates)
				var world_min = bounds[0]
				var world_max = bounds[1]
				
				min_x = min(min_x, world_min.x)
				min_y = min(min_y, world_min.y)
				max_x = max(max_x, world_max.x)
				# For max_y, prioritize Apartment tilemap to avoid grey space
				if tilemap == apartment_tilemap:
					max_y = max(max_y, world_max.y)
				elif max_y == -INF:  # Only use other tilemaps if Apartment not found
					max_y = max(max_y, world_max.y)
	
	# If we have an Apartment tilemap, use its bottom bound for max_y
	if apartment_tilemap and apartment_tilemap.has_method("getTileMapBounds"):
		var bounds = apartment_tilemap.getTileMapBounds()
		if bounds.size() >= 2:
			# bounds already in world coordinates, no need to add tilemap_pos
			var apartment_max_y = bounds[1].y
			max_y = apartment_max_y  # Use Apartment's bottom as the limit
	
	# Set the combined bounds
	if min_x != INF and min_y != INF and max_x != -INF and max_y != -INF:
		var combined_bounds: Array[Vector2] = [Vector2(min_x, min_y), Vector2(max_x, max_y)]
		LevelManager.ChangeTileMapBounds(combined_bounds)
