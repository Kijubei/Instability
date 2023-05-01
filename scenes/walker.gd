class_name Walker

extends CharacterBody3D

@export_category("Customization")
@export var bumpPower = 50
@export var moveSpeed = 7

@onready var animationTree: AnimationTree = $"animations-treadmill/AnimationTree"

var active = false

func _process(delta):
	if active:
		move(delta)

func move(delta):
	velocity.z = moveSpeed * delta * 60
	
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
		active = true

func _on_activation_area_body_exited(body):
	if body is UnstablePlayer:
		active = false
		self.queue_free()
