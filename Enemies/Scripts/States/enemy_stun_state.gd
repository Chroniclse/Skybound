class_name EnemyStateStun extends EnemyState


@export var anim_name : String = "stun"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export_category("AI")
@export var next_state : EnemyState = null

var _timer : float
var _direction : Vector2
var animation_finished : bool = false
func init() -> void:
	enemy.enemy_damaged.connect(on_enemy_damaged)
	pass
func enter() -> void:
	enemy.invlunerable = true
	animation_finished = false
	_direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.velocity = _direction*-1*knockback_speed
	enemy.set_direction(_direction)
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	pass

func exit() -> void:
	enemy.invlunerable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass
func process(_delta : float) -> EnemyState:
	if animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
func on_enemy_damaged() -> void:
	state_machine.change_state(self)

func _on_animation_finished(_a : String) -> void:
	animation_finished = true
	
