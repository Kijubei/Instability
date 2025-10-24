class_name MoodShift
extends Node3D

signal started
signal complete(directionMultiplier: int)

@export_category("Init")
@export var world: Node3D
@export var player: Node3D
@export_category("Customization")
@export var rotationMultiplier = 10
@export var rotationVarianceMin = -6
@export var rotationVarianceMax = 6
@export var rotationType = Tween.TRANS_SINE
@export var easeType = Tween.EASE_IN_OUT

@onready var tween: Tween = create_tween()

func _ready():
	assert(world, "world not initialized for mood_shift")
	assert(player, "player not initialized for mood_shift")
	
	tween.pause()

func shift(directionMultiplier):
	if is_shift_possible(directionMultiplier) and not tween.is_running():
		emit_signal("started")
		shiftWorld(directionMultiplier)

func shiftWorld(directionMultiplier: int):
	var player_pos = player.global_position
	var angle_deg = 90 * directionMultiplier + variance()
	var time: float = 10.0 / rotationMultiplier
	# Ich weiß nicht warum der hier immer wieder erstellt werden muss
	var tween = create_tween()

	# Startzustand speichern
	var start_basis = world.global_transform.basis
	var start_origin = world.global_transform.origin

	tween.tween_method(
		rotateWorld.bind(player_pos, start_basis, start_origin, angle_deg),
		0.0, 1.0, time
	).set_trans(rotationType).set_ease(easeType)

	tween.finished.connect(moodShiftDone.bind(directionMultiplier))

# --- Rotiert die Welt um die Z Achse vom Spieler ---
func rotateWorld(p: float, player_pos: Vector3, start_basis: Basis, start_origin: Vector3, angle_deg: float) -> void:
	var rot = deg_to_rad(angle_deg * p)
	var rot_quat = Quaternion(Vector3(0, 0, 1), rot)
	var rot_basis = Basis(rot_quat)

	# Welt um den Spieler rotieren
	var offset = start_origin - player_pos # Different zwischen Spieler und Welt
	offset = rot_basis * offset

	world.global_transform.origin = player_pos + offset
	world.global_transform.basis = rot_basis * start_basis


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
