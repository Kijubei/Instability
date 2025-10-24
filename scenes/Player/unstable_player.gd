class_name UnstablePlayer

extends CharacterBody3D

enum PlayerState {
	idle,
	walk,
	run,
	jump,
	bodied,
	fainted,
	floating,
}

const hLookSensibility = 0.2
const vLookSensibility = 0.2

@export_category("Movement")
@export var gravity_multiplier = 3
@export var speed = 7.0
@export var acceleration = 3
@export var deceleration = 2
@export var air_control = 0.3
@export var jump_height = 10
@export var run_speed_multiplier = 1.6
@export var floating_height = 5

var state: int = PlayerState.idle

@onready var pillUI: PillUI = $PillUI
@onready var energy: PlayerEnergy = $EnergyUI/PlayerEnergy
@onready var moodShift: MoodShift = $MoodShift
@onready var cameraBase = $CameraBase
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)
@onready var animationTree: AnimationTree = $"animations-treadmill/AnimationTree"

func _input(event):
	if event is InputEventMouseMotion:
		cameraBase.rotation_degrees.x -= event.relative.y * vLookSensibility
		cameraBase.rotation_degrees.x = clamp(cameraBase.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * hLookSensibility

func _physics_process(delta):
	state = getCurrentState()
	checkActions()
	applyGravity(delta)
	applyState(delta)
	

func getCurrentState() -> PlayerState:
	if state == PlayerState.fainted:
		return PlayerState.fainted
	
	if state == PlayerState.floating:
		return PlayerState.floating
	
	if not is_on_floor():
		return PlayerState.jump
	
	if state == PlayerState.bodied:
		if velocity.x == 0 and velocity.z == 0:
			return PlayerState.idle	
		return PlayerState.bodied
	
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO:
		if Input.is_action_pressed("run") and energy.value > energy.min_value:
			return PlayerState.run
		return PlayerState.walk
	
	return PlayerState.idle

func checkActions():
	if pillUI.pills > 0 and state != PlayerState.fainted and state != PlayerState.bodied:
		if Input.is_action_just_released("mood_shift_left"):
			moodShift.shift(1)

		if Input.is_action_just_released("mood_shift_right"):
			moodShift.shift(-1)

func applyGravity(delta):
	if not is_on_floor() and state != PlayerState.floating:
		velocity.y -= gravity * delta

func applyState(delta):
	match state:
		PlayerState.idle:
			idle(delta)
		PlayerState.walk:
			walk(delta)
		PlayerState.run:
			run(delta)
		PlayerState.jump:
			jump(delta)
		PlayerState.bodied:
			bodied(delta)
		PlayerState.fainted:
			fainted(delta)
		PlayerState.floating:
			floating(delta)

func _on_mood_shift_started():
	state = PlayerState.floating

func _on_mood_shift_complete(_directionMultiplier):
	if state != PlayerState.fainted and state != PlayerState.bodied:
		state = PlayerState.jump

func idle(delta):
	animationTree.set("parameters/movements/transition_request", "Idle")
	applyInput(delta)

func walk(delta):
	animationTree.set("parameters/movements/transition_request", "Walk")
	applyInput(delta)

func run(delta):
	animationTree.set("parameters/movements/transition_request", "Run")
	applyInput(delta)

func jump(delta):
	animationTree.set("parameters/movements/transition_request", "Jump")
	applyInput(delta)

func bodied(delta):
	animationTree.set("parameters/movements/transition_request", "Bodied")
	velocity.x = move_toward(velocity.x, 0, deceleration * 60 * delta)
	velocity.z = move_toward(velocity.z, 0, deceleration * 60 * delta)
	
	move_and_slide()

func fainted(delta):
	animationTree.set("parameters/movements/transition_request", "Faint")
	velocity.x = move_toward(velocity.x, 0, deceleration * 60 * delta)
	velocity.z = move_toward(velocity.z, 0, deceleration * 60 * delta)
	
	move_and_slide()
	
func floating(delta):
	animationTree.set("parameters/movements/transition_request", "Use")
	# Float a bit in the air
	velocity.y = floating_height
	applyInput(delta)

func applyInput(delta):
	var maxSpeed = speed
	if Input.is_action_pressed("run") and energy.value > energy.min_value:
		energy.useToRun()
		maxSpeed *= run_speed_multiplier
	else:
		energy.recover()
	
	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_height
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.x != 0 and direction.z != 0:
		direction = velocity.move_toward(direction * maxSpeed, acceleration * 60 * delta)
		velocity.x = direction.x
		velocity.z = direction.z
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * 60 * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * 60 * delta )
		
	
	move_and_slide()

func getBodied(bumpPower, directionNormalized):
	if state != PlayerState.fainted:
		state = PlayerState.bodied
	velocity = velocity.move_toward(directionNormalized * bumpPower, bumpPower)

func gainPill():
	if pillUI.pills < pillUI.max_pills:
		pillUI.setPills(pillUI.pills+1)
	energy.boostEnergy()

func faint():
	state = PlayerState.fainted
