class_name playerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure camera is current and enabled
	enabled = true
	offset = Vector2.ZERO
	position = Vector2.ZERO  # Ensure camera is at (0,0) relative to player
	make_current()
	
	# Disable smoothing to ensure immediate following
	position_smoothing_enabled = false
	
	# Wait a frame to ensure LevelManager is ready
	await get_tree().process_frame
	
	# Set zoom for specific levels
	if LevelManager:
		if LevelManager.current_level_path.contains("Level1"):
			zoom = Vector2(1.5, 1.5)
		elif LevelManager.current_level_path.contains("Level2"):
			zoom = Vector2(1.5, 1.5)  # 1.5x zoom for Level 2
	
	if LevelManager:
		LevelManager.TileMapBoundsChanged.connect( updateLimits )
		# Check if bounds are already set (they might have been set before camera loaded)
		var current_bounds = LevelManager.current_tilemap_bounds
		if current_bounds != null and current_bounds.size() >= 2:
			updateLimits(current_bounds)
	
	# Ensure camera stays current (sometimes it gets overridden)
	await get_tree().process_frame
	make_current()
	
	# Ensure camera position is (0,0) relative to player (should be automatic, but just to be sure)
	position = Vector2.ZERO


func updateLimits(bounds : Array[Vector2]) -> void:
	# For Level 3, disable all camera limits - let it operate normally
	if LevelManager and LevelManager.current_level_path.contains("Level1"):
		limit_left = -10000000
		limit_top = -10000000
		limit_right = 10000000
		limit_bottom = 10000000
		limit_smoothed = false
		position = Vector2.ZERO
		make_current()
		return
	
	if bounds == null or bounds.size() < 2: 
		return
	
	# Get viewport size to account for camera view boundaries
	# Camera limits define where the camera CENTER can go, not the view edges
	var viewport_size = get_viewport_rect().size
	var half_width = viewport_size.x / 2.0
	var half_height = viewport_size.y / 2.0
	
	# Set limits so camera center can't go outside bounds
	# This ensures the camera view doesn't extend beyond tile boundaries
	limit_left = int(bounds[0].x + half_width)
	limit_top = int(bounds[0].y + half_height)
	limit_right = int(bounds[1].x - half_width)
	limit_bottom = int(bounds[1].y - half_height)
	
	# Disable limit smoothing to ensure camera follows immediately
	limit_smoothed = false
	
	# Ensure camera position is (0,0) relative to player (should be automatic, but reset to be sure)
	position = Vector2.ZERO
	
	# Ensure camera is current
	make_current()
	pass
