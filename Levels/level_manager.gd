extends Node2D

var enemies: Array[Enemy] = []
var player_near_win_area: bool = false
var player_near_tv: bool = false

func _ready() -> void:
	# Set player scale based on level
	var level_scale = 1.0
	if LevelManager.current_level_path.contains("Level1"):
		level_scale = 0.8
	elif LevelManager.current_level_path.contains("Level2"):
		level_scale = 1.0 / 1.5  # Scale down by 1.5x = 0.667
	
	if PlayerManager.player:
		PlayerManager.player.scale = Vector2(level_scale, level_scale)
	
	# Wait a frame for all nodes to be ready
	await get_tree().process_frame
	
	# Set camera bounds for this level
	_set_level_camera_bounds()
	
	# Position player at bottom right corner
	_position_player_bottom_right()
	
	# Connect to win interaction if it exists in the scene
	_setup_win_interaction()
	
	# For Level 1 and Level 2, connect to TV interaction if it exists
	if LevelManager.current_level_path.contains("Level1") or LevelManager.current_level_path.contains("Level2"):
		_setup_tv_interaction()
	
	# Find all enemies in the scene
	_find_all_enemies()
	
	# Connect to enemy destroyed signals
	for enemy in enemies:
		if enemy and is_instance_valid(enemy):
			if not enemy.enemy_destroyed.is_connected(_on_enemy_destroyed):
				enemy.enemy_destroyed.connect(_on_enemy_destroyed)

func _find_all_enemies() -> void:
	enemies.clear()
	# Find all Enemy nodes in the scene tree recursively
	_find_enemies_recursive(self)

func _find_enemies_recursive(node: Node) -> void:
	for child in node.get_children():
		if child is Enemy:
			if not enemies.has(child):
				enemies.append(child)
		_find_enemies_recursive(child)

func _on_enemy_destroyed(_hurt_box: HurtBox) -> void:
	# Remove destroyed enemies from the list
	enemies = enemies.filter(func(enemy): return is_instance_valid(enemy) and enemy.is_inside_tree())
	
	# Check if all enemies are defeated
	if enemies.is_empty():
		# All enemies defeated - trigger win screen
		LevelManager.level_completed.emit()

func _position_player_bottom_right() -> void:
	# Wait for player to be ready
	if not PlayerManager.player:
		await get_tree().create_timer(0.1).timeout
		if not PlayerManager.player:
			return
	
	# For Level 1 and Level 2, use the PlayerSpawn node position directly (no calculations)
	if LevelManager.current_level_path.contains("Level1") or LevelManager.current_level_path.contains("Level2"):
		var player_spawn = _find_node_recursive(self, "PlayerSpawn")
		if player_spawn:
			PlayerManager.player.global_position = player_spawn.global_position
			print("Level Manager: Positioned player at PlayerSpawn node: ", player_spawn.global_position)
			return
	
	# For other levels, use calculated bottom right position
	# Get bounds from LevelManager
	var bounds = LevelManager.current_tilemap_bounds
	if bounds == null or bounds.size() < 2:
		# If bounds not set yet, wait a bit more
		await get_tree().create_timer(0.1).timeout
		bounds = LevelManager.current_tilemap_bounds
		if bounds == null or bounds.size() < 2:
			print("Level Manager: No bounds available for player positioning")
			return
	
	# bounds[0] is top-left, bounds[1] is bottom-right
	# Position player at bottom right with some padding from edges
	# Need to account for camera limits - camera center can't go to the very edge
	var viewport_size = get_viewport_rect().size
	var half_width = viewport_size.x / 2.0
	var half_height = viewport_size.y / 2.0
	var padding = 32.0  # Padding from the edge
	
	# Camera limits are: left = bounds[0].x + half_width, right = bounds[1].x - half_width
	# So the camera center can go from (bounds[0].x + half_width) to (bounds[1].x - half_width)
	# We want to spawn at bottom right, but within camera limits
	var camera_limit_left = bounds[0].x + half_width
	var camera_limit_right = bounds[1].x - half_width
	var camera_limit_top = bounds[0].y + half_height
	var camera_limit_bottom = bounds[1].y - half_height
	
	var max_camera_x = camera_limit_right  # Rightmost camera center position
	var spawn_x = max_camera_x - padding  # Spawn a bit left of the rightmost camera position
	var spawn_y = camera_limit_bottom - padding  # Bottom Y, accounting for camera view
	
	print("Level Manager: Camera limits - L:", camera_limit_left, " R:", camera_limit_right, " T:", camera_limit_top, " B:", camera_limit_bottom)
	print("Level Manager: Calculated spawn position: ", Vector2(spawn_x, spawn_y))
	print("Level Manager: Player current position before spawn: ", PlayerManager.player.global_position if PlayerManager.player else "no player")
	
	PlayerManager.player.global_position = Vector2(spawn_x, spawn_y)
	
	# Force position update
	PlayerManager.player.global_position = Vector2(spawn_x, spawn_y)
	
	# Ensure camera follows player after positioning
	var camera = PlayerManager.player.get_node_or_null("Camera2D")
	if camera:
		camera.position = Vector2.ZERO
		camera.make_current()
		camera.enabled = true
	
	print("Level Manager: Positioned player at bottom right: ", Vector2(spawn_x, spawn_y))
	print("Level Manager: Player position after spawn: ", PlayerManager.player.global_position)
	


func _set_level_camera_bounds() -> void:
	# Find all tilemaps in the level and calculate combined bounds
	var all_tilemaps = []
	for child in get_children():
		if child is TileMap:
			all_tilemaps.append(child)
	
	print("Level Manager: Found ", all_tilemaps.size(), " tilemaps")
	
	if all_tilemaps.is_empty():
		print("Level Manager: No tilemaps found!")
		return
	
	# Calculate the combined bounds of all tilemaps
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF
	
	for tilemap in all_tilemaps:
		print("Level Manager: Checking tilemap: ", tilemap.name, " - has getTileMapBounds: ", tilemap.has_method("getTileMapBounds"))
		if tilemap.has_method("getTileMapBounds"):
			var bounds = tilemap.getTileMapBounds()
			print("Level Manager: Got bounds from ", tilemap.name, ": ", bounds)
			if bounds.size() >= 2:
				# bounds[0] is top-left, bounds[1] is bottom-right (already in world coordinates)
				var world_min = bounds[0]
				var world_max = bounds[1]
				
				min_x = min(min_x, world_min.x)
				min_y = min(min_y, world_min.y)
				max_x = max(max_x, world_max.x)
				max_y = max(max_y, world_max.y)
	
	# Set the combined bounds
	if min_x != INF and min_y != INF and max_x != -INF and max_y != -INF:
		var combined_bounds: Array[Vector2] = [Vector2(min_x, min_y), Vector2(max_x, max_y)]
		print("Level Manager: Setting combined bounds: ", combined_bounds)
		LevelManager.ChangeTileMapBounds(combined_bounds)
	else:
		print("Level Manager: Invalid bounds calculated - min: (", min_x, ", ", min_y, ") max: (", max_x, ", ", max_y, ")")


func _setup_win_interaction() -> void:
	# Look for WinInteraction node in the scene
	var win_interaction = _find_node_recursive(self, "WinInteraction")
	if win_interaction:
		# Connect to win interaction signals
		win_interaction.player_entered_range.connect(_on_win_area_entered)
		win_interaction.player_exited_range.connect(_on_win_area_exited)


func _find_node_recursive(node: Node, node_name: String) -> Node:
	if node.name == node_name:
		return node
	for child in node.get_children():
		var found = _find_node_recursive(child, node_name)
		if found:
			return found
	return null


func _on_win_area_entered() -> void:
	player_near_win_area = true
	# Show hint to player
	if PlayerHud:
		PlayerHud.show_hint("Press X to interact")


func _on_win_area_exited() -> void:
	player_near_win_area = false
	# Hide hint
	if PlayerHud:
		PlayerHud.hide_hint()


func _setup_tv_interaction() -> void:
	# Look for TVInteraction node in the scene
	var tv_interaction = _find_node_recursive(self, "TVInteraction")
	if tv_interaction:
		# Connect to TV interaction signals
		tv_interaction.player_entered_range.connect(_on_tv_entered_range)
		tv_interaction.player_exited_range.connect(_on_tv_exited_range)


func _on_tv_entered_range() -> void:
	player_near_tv = true
	# Show hint to player
	if PlayerHud:
		PlayerHud.show_hint("Press X to interact")


func _on_tv_exited_range() -> void:
	player_near_tv = false
	# Hide hint
	if PlayerHud:
		PlayerHud.hide_hint()


func _input(event: InputEvent) -> void:
	# For Level 1 and Level 2, check for X press when player is near TV
	if LevelManager.current_level_path.contains("Level1") or LevelManager.current_level_path.contains("Level2"):
		if event.is_action_pressed("Interact") and player_near_tv:
			# Player completed the level via TV interaction!
			LevelManager.level_completed.emit()
			var viewport = get_viewport()
			if viewport:
				viewport.set_input_as_handled()
			return
	
	# Check for X press when player is near win area (for any level with WinInteraction)
	if event.is_action_pressed("Interact") and player_near_win_area:
		# Player completed the level!
		LevelManager.level_completed.emit()
		var viewport = get_viewport()
		if viewport:
			viewport.set_input_as_handled()
