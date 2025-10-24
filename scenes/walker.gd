class_name Walker

extends CharacterBody3D

@export_category("Customization")
@export var bumpPower = 50
@export var moveSpeed = 7

@onready var animationTree: AnimationTree = $"animations-treadmill/AnimationTree"

var direction = Vector3(0,0,1)

func _ready():
	self.visible = false

func setYRotation(yRotation: float):
	direction = direction.rotated(Vector3(0,1,0), yRotation)

func _process(delta):
	if self.visible:
		move(delta)

func move(delta):
	#vielleicht mit look at?
	velocity = direction
	velocity.z = moveSpeed * delta * 60
	#velocity.normalized() # die bewegen sich noch zu schnell 
	
	if velocity.z != 0 or velocity.x != 0:
		animationTree.set("parameters/movements/transition_request", "Walk")
	else:
		animationTree.set("parameters/movements/transition_request", "Idle")
	
	#move_and_slide()
	var collision = move_and_collide(velocity * delta)
	if collision:
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		reflect.y = 0
		direction = reflect
		look_at(direction)
		#yRotation = 
		#velocity = velocity.bounce(collision.get_normal())
		#move_and_collide(reflect)

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
