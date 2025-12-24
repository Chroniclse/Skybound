class_name State_Attack extends State

var attacking : bool = false
@export var attack_sound : AudioStream
@export_range (1,20,0.5) var decelerate_speed :float = 5.0

@onready var hurt_box : hurt_box = %AttackHurtBox
@onready var walk : State = $ "../Walk"
@onready var idle : State = $ "../Idle"
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim : AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var attack : State = $ "../Attack"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
func Enter() -> void:
	player.updateAnimation("attack")
	attack_anim.play("attack_" + player.animateDirection())
	animation_player.animation_finished.connect(endAttack)
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9,1.1)
	audio.play()
	attacking = true
	await get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true
	
	pass

func Exit() -> void:
	animation_player.animation_finished.disconnect( endAttack)
	attacking = false
	hurt_box.monitoring = false
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
	player.velocity -= (player.velocity * decelerate_speed * _delta)
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
		
	return null
	
func Physics(_delta: float) -> State:
	return null

func HandleInput(_event : InputEvent) -> State:
	if _event.is_action_pressed("Attack"):
		return attack
	return null

func endAttack (_newAnimeName : String) -> void:
	attacking = false
