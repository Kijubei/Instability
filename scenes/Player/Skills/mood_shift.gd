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
	if not world:
		push_error("world not initialized for mood_shift")
		get_tree().quit()
		return
		
	tween.pause()
	
func shift(directionMultiplier: int):

	if tween.is_running():
		return
	
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

func _on_unstable_player_mood_shift(directionMultiplier):
	if is_shift_possible(directionMultiplier):
		emit_signal("started")
		shift(directionMultiplier)

func moodShiftDone(directionMultiplier: int):
	tween.pause()
	emit_signal("complete", directionMultiplier)
