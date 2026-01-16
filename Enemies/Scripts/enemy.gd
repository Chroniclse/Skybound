class_name Enemy extends CharacterBody2D


signal direction_changed(new_direction : Vector2)
signal enemy_damaged(hurt_box : HurtBox)
signal enemy_destroyed(hurt_box : HurtBox)
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invlunerable : bool = false

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shadow_sprite = get_node_or_null("ShadowSprite2D")
	if shadow_sprite:
		var shadow_data = {
			"z_index": shadow_sprite.z_index,
			"y_sort_enabled": shadow_sprite.y_sort_enabled,
			"position": {"x": shadow_sprite.position.x, "y": shadow_sprite.position.y},
			"global_position": {"x": shadow_sprite.global_position.x, "y": shadow_sprite.global_position.y},
			"is_visible": shadow_sprite.visible,
			"parent_name": shadow_sprite.get_parent().name if shadow_sprite.get_parent() else "none"
		}
		var log_data = {
			"sessionId": "debug-session",
			"runId": "run1",
			"hypothesisId": "A",
			"location": "enemy.gd:_ready",
			"message": "ShadowSprite2D rendering properties",
			"data": shadow_data,
			"timestamp": Time.get_ticks_msec()
		}
		var json = JSON.new()
		var log_entry = json.stringify(log_data)
		var file = FileAccess.open("/Users/bijuvarghese/Documents/Skybound/.cursor/debug.log", FileAccess.WRITE_READ)
		if file:
			file.seek_end()
			file.store_string(log_entry + "\n")
			file.close()
	
	var sprite_data = {
		"z_index": sprite.z_index,
		"y_sort_enabled": sprite.y_sort_enabled,
		"position": {"x": sprite.position.x, "y": sprite.position.y},
		"global_position": {"x": sprite.global_position.x, "y": sprite.global_position.y},
		"is_visible": sprite.visible,
		"parent_name": sprite.get_parent().name if sprite.get_parent() else "none"
	}
	var log_data2 = {
		"sessionId": "debug-session",
		"runId": "run1",
		"hypothesisId": "B",
		"location": "enemy.gd:_ready",
		"message": "Sprite2D rendering properties",
		"data": sprite_data,
		"timestamp": Time.get_ticks_msec()
	}
	var json2 = JSON.new()
	var log_entry2 = json2.stringify(log_data2)
	var file2 = FileAccess.open("/Users/bijuvarghese/Documents/Skybound/.cursor/debug.log", FileAccess.WRITE_READ)
	if file2:
		file2.seek_end()
		file2.store_string(log_entry2 + "\n")
		file2.close()
	

	var parent_data = {
		"z_index": z_index,
		"y_sort_enabled": y_sort_enabled,
		"position": {"x": position.x, "y": position.y},
		"global_position": {"x": global_position.x, "y": global_position.y},
		"child_count": get_child_count(),
		"children": []
	}
	for i in range(get_child_count()):
		var child = get_child(i)
		if child is Sprite2D:
			parent_data.children.append({
				"name": child.name,
				"z_index": child.z_index,
				"y_sort_enabled": child.y_sort_enabled,
				"position_y": child.position.y
			})
	var log_data3 = {
		"sessionId": "debug-session",
		"runId": "run1",
		"hypothesisId": "C",
		"location": "enemy.gd:_ready",
		"message": "Parent CharacterBody2D rendering properties",
		"data": parent_data,
		"timestamp": Time.get_ticks_msec()
	}
	var json3 = JSON.new()
	var log_entry3 = json3.stringify(log_data3)
	var file3 = FileAccess.open("/Users/bijuvarghese/Documents/Skybound/.cursor/debug.log", FileAccess.WRITE_READ)
	if file3:
		file3.seek_end()
		file3.store_string(log_entry3 + "\n")
		file3.close()
	
	
	add_to_group("enemies")
	state_machine.Initialize(self)
	player = PlayerManager.player
	hit_box.Damaged.connect(_take_damage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func set_direction(_new_direction: Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO: return false
	var direction_id : int = int(round(direction + cardinal_direction * 0.1).angle()/TAU * DIR_4.size())
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direction: return false
	
	cardinal_direction = _new_direction
	direction_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true	


func update_animation(state : String) -> void:
	animation_player.play(state + "_" + anim_direction())
	pass
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else: 
		return "side"

func _take_damage(hurt_box : HurtBox) -> void:
	if invlunerable == true:
		return
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
