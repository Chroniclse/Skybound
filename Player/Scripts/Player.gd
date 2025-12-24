class_name Player extends CharacterBody2D


var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
const  DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

signal DirectionChanged (new_direction : Vector2)

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)


# --- Direction Logic ---

func setDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	var direction_id : int = int ( round( (direction + cardinal_direction*0.1).angle() / TAU * DIR_4.size() ) )		
	var new_dir = DIR_4[direction_id]
	
	
	
	if new_dir == cardinal_direction:
		return false 
		

	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)

	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true 

# --- State Logic ---


# --- Animation Helpers ---

func animateDirection() -> String: 
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else: 
		return "side"

func updateAnimation(state : String) -> void:
	
	var anim_dir = animateDirection() 
	animation_player.play(state + "_" + anim_dir)
	
# --- Game Loop Functions ---

@warning_ignore("unused_parameter")
func _process(delta):
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	direction = Vector2(
		Input.get_axis("Left", "Right"),
		Input.get_axis("Up", "Down")
	).normalized()
	
	
	
	
	
@warning_ignore("unused_parameter")
func _physics_process( delta ) :
	move_and_slide()
