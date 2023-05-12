class_name MoodShift
extends Node3D

signal started
signal complete(directionMultiplier: int)

@export_category("Customization")
@export var world: Node3D
@export var rotaionMultiplier = 10
@export var rotationVarianceMin = -6
@export var rotationVarianceMax = 6
@export var rotationType = Tween.TRANS_SINE
@export var easeType = Tween.EASE_IN_OUT

@onready var tween: Tween = create_tween()

func _ready():
	assert(world, "world not initialized for mood_shift")
	
	tween.pause()

func shift(directionMultiplier):
	if is_shift_possible(directionMultiplier) and not tween.is_running():
		emit_signal("started")
		shiftWorld(directionMultiplier)

func shiftWorld(directionMultiplier: int):
	
	# Ich weiß nicht warum der hier immer wieder erstellt werden muss
	tween = create_tween()
	var target = 90*directionMultiplier + variance()
	var time: float = 10.0 / rotaionMultiplier
	tween.tween_property(world, "rotation_degrees:z", target, time).as_relative().set_trans(rotationType).set_ease(easeType)
	tween.finished.connect(moodShiftDone.bind(directionMultiplier))
	tween.play()
	

## Makes sure the player does not kill himself
func is_shift_possible(directionMultiplier: int) -> bool:
	if (world.rotation_degrees.z + 90 * directionMultiplier > 135):
		return false
	if (world.rotation_degrees.z + 90 * directionMultiplier < -135):
		return false
	return true

func variance() -> int:
	return randi_range(rotationVarianceMin, rotationVarianceMax)

func moodShiftDone(directionMultiplier: int):
	tween.pause()
	emit_signal("complete", directionMultiplier)
