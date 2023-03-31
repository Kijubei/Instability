class_name UnstablePlayer

extends CharacterBody3D

signal mood_shift(directionMultiplier: int)

enum PlayerState {
	walk,
	sprint,
	bodied,
}

const hLookSensibility = 0.2
const vLookSensibility = 0.2

@export_category("Movement")
@export var gravity_multiplier = 3
@export var speed = 10.0
@export var acceleration = 3
@export var deceleration = 2
@export var air_control = 0.3
@export var jump_height = 10
@export var sprint_speed_multiplier = 1.6

var _state = walk

@onready var cameraBase = $CameraBase
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)

func _input(event):
	if event is InputEventMouseMotion:
		cameraBase.rotation_degrees.x -= event.relative.y * vLookSensibility
		cameraBase.rotation_degrees.x = clamp(cameraBase.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * hLookSensibility

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	checkState()
	checkActions()

	match _state:
		walk:
			walk(delta)
		sprint:
			sprint(delta)
		bodied:
			bodied(delta)
	

func checkState():
	if _state == bodied:
		if velocity.x == 0 and velocity.z == 0:
			_state = walk
		return 
	
	if Input.is_action_pressed("sprint"):
		_state = sprint
	else:
		_state = walk
		
func checkActions():
	if Input.is_action_just_released("mood_shift_left"):
		moodShift(1)
	if Input.is_action_just_released("mood_shift_right"):
		moodShift(-1)
		

func moodShift(direction: int):
	emit_signal("mood_shift", direction)

func walk(delta):
	applyInput(delta)

func sprint(delta):
	applyInput(delta)
	
func bodied(delta):
	velocity.x = move_toward(velocity.x, 0, deceleration * 60 * delta)
	velocity.z = move_toward(velocity.z, 0, deceleration * 60 * delta)
	
	move_and_slide()

func applyInput(delta):
	var maxSpeed = speed * sprint_speed_multiplier if _state == sprint else speed
	
	# Handle Jump.
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
	_state = bodied
	
	velocity = velocity.move_toward(directionNormalized * bumpPower, bumpPower)
