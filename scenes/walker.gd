class_name Walker

extends CharacterBody3D

@export_category("Customization")
@export var bumpPower = 50
@export var moveSpeed = 7

@onready var animationTree: AnimationTree = $"animations-treadmill/AnimationTree"

func _process(delta):
	velocity.z = moveSpeed * delta * 60
	print(velocity.z)
	
	if velocity.z != 0 or velocity.x != 0:
		animationTree.set("parameters/movements/transition_request", "Walk")
	else:
		animationTree.set("parameters/movements/transition_request", "Idle")
	
	move_and_slide()

func _on_area_3d_body_entered(body):
	if body is UnstablePlayer:
		var directionNormalized = (self.position - body.position).normalized()
		body.getBodied(bumpPower, directionNormalized)
	
