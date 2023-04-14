class_name UnstablePlayer

extends CharacterBody3D

signal mood_shift(directionMultiplier: int)

enum PlayerState {
	idle,
	walk,
	run,
	jump,
	bodied,
	fainted,
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

var state: int = PlayerState.idle

@onready var pillUI: PillUI = $PillUI
@onready var cameraBase = $CameraBase
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)
@onready var animationPlayer: AnimationPlayer = $animationsSetup/AnimationPlayer

func _input(event):
	if event is InputEventMouseMotion:
		cameraBase.rotation_degrees.x -= event.relative.y * vLookSensibility
		cameraBase.rotation_degrees.x = clamp(cameraBase.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * hLookSensibility

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	state = getCurrentState()
	checkActions()
	
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
	

func getCurrentState() -> PlayerState:
	if state == PlayerState.fainted:
		return PlayerState.fainted
	
	if not is_on_floor():
		return PlayerState.jump
	
	if state == PlayerState.bodied:
		if velocity.x == 0 and velocity.z == 0:
			return PlayerState.idle
	
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO:
		if Input.is_action_pressed("run"):
			return PlayerState.run
		return PlayerState.walk
	
	return PlayerState.idle

func checkActions():
	if pillUI.pills > 0:
		if Input.is_action_just_released("mood_shift_left"):
			moodShift(1)

		if Input.is_action_just_released("mood_shift_right"):
			moodShift(-1)

func moodShift(direction: int):
	emit_signal("mood_shift", direction)

func idle(delta):
	animationPlayer.play("idle")
	applyInput(delta)

func walk(delta):
	animationPlayer.play("walk")
	applyInput(delta)

func run(delta):
	animationPlayer.play("run")
	applyInput(delta)

func jump(delta):
	animationPlayer.play("jump")
	applyInput(delta)

func bodied(delta):
	animationPlayer.play("use")
	velocity.x = move_toward(velocity.x, 0, deceleration * 60 * delta)
	velocity.z = move_toward(velocity.z, 0, deceleration * 60 * delta)
	
	move_and_slide()

func fainted(delta):
	animationPlayer.play("use")
	velocity.x = move_toward(velocity.x, 0, deceleration * 60 * delta)
	velocity.z = move_toward(velocity.z, 0, deceleration * 60 * delta)
	
	move_and_slide()

func applyInput(delta):
	var maxSpeed = speed * run_speed_multiplier if state == PlayerState.run else speed
	
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

func _on_leute_get_bodied_from_people(bumpPower, directionNormalized):
	if state != PlayerState.fainted:
		state = PlayerState.bodied
	velocity = velocity.move_toward(directionNormalized * bumpPower, bumpPower)

func gainPill():
	if pillUI.pills < pillUI.max_pills:
		pillUI.setPills(pillUI.pills+1)

func faint():
	state = PlayerState.fainted
