extends CharacterBody3D

@export_category("Customization")
@export var moveSpeed = 3
@export var groupBumpPower = 50

@onready var walker1 = $"Walker"
@onready var walker2 = $"Walker2"
@onready var walker3 = $"Walker3"

signal getBodiedFromGroup(bumpPower, directionNormalized)

# Called when the node enters the scene tree for the first time.
func _ready():
	walker1.bumpPower = groupBumpPower
	walker2.bumpPower = groupBumpPower
	walker3.bumpPower = groupBumpPower

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity.z = moveSpeed
	self.move_and_slide()


func _on_walker_get_bodied(bumpPower, directionNormalized):
	emit_signal("getBodiedFromGroup", bumpPower, directionNormalized)

func _on_walker_2_get_bodied(bumpPower, directionNormalized):
	emit_signal("getBodiedFromGroup", bumpPower, directionNormalized)

func _on_walker_3_get_bodied(bumpPower, directionNormalized):
	emit_signal("getBodiedFromGroup", bumpPower, directionNormalized)
