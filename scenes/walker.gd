class_name Walker

extends CharacterBody3D

@export_category("Customization")
@export var bumpPower = 50
@export var moveSpeed = 7
#@export var direction = Vector3.FORWARD

@onready var animationTree: AnimationTree = $"animations-treadmill/AnimationTree"

func _ready():
	self.visible = false

func _process(delta):
	if self.visible:
		move(delta)

func move(delta):
	velocity.z = moveSpeed * delta * 60

	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var baseDirection = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#var baseDirection = (transform.basis * Vector3(1,0,0)).normalized()
	#if baseDirection.x != 0 and baseDirection.z != 0:
		#baseDirection = velocity.move_toward(baseDirection * moveSpeed, moveSpeed * 60 * delta)
		#velocity.x = baseDirection.x
		#velocity.z = baseDirection.z
	
	if velocity.z != 0 or velocity.x != 0:
		animationTree.set("parameters/movements/transition_request", "Walk")
	else:
		animationTree.set("parameters/movements/transition_request", "Idle")
	
	move_and_slide()

func _on_bump_area_body_entered(body):
	if body is UnstablePlayer:
		var directionNormalized = (self.position - body.position).normalized()
		body.getBodied(bumpPower, directionNormalized)

func _on_activation_area_body_entered(body):
	if body is UnstablePlayer:
		visible = true

func _on_activation_area_body_exited(body):
	if body is UnstablePlayer:
		visible = false
		self.queue_free()
