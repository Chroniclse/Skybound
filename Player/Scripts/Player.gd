class_name Player extends CharacterBody2D


var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

func _ready() -> void:
	state_machine.Initialize(self)


# --- Direction Logic ---

func setDirection() -> bool:
	var new_dir = cardinal_direction
	
	# 1. If not moving, do not change facing direction
	if direction == Vector2.ZERO:
		return false
		
	# 2. Determine the new cardinal direction based on input
	#    (Logic to handle keyboard or d-pad input priority)
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	
	
	if new_dir == cardinal_direction:
		return false 
		

	cardinal_direction = new_dir
	

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

func _process(delta):
	
	
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	direction = Vector2(
		Input.get_axis("Left", "Right"),
		Input.get_axis("Up", "Down")
	).normalized()
	
	
	
	
	
func _physics_process( delta ) :
	move_and_slide()
