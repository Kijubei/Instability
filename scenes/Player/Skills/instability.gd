extends Node3D

@export_category("Customization")
@export var world: Node3D
@export var roationMultiplier = 2
@export var rotationDelay = 1

var tween: Tween

func _ready():
	if not world:
		push_error("world not initialized for instability")
		get_tree().quit()

	turnWorld(randomDirection())


func turnWorld(inDirection: int):
	tween = create_tween()
	tween.tween_property(world,"rotation_degrees:z",180*inDirection, 60*roationMultiplier).as_relative().set_delay(rotationDelay)


func randomDirection() -> int:
	var directions = [-1,1]
	return directions[randi() % directions.size()]


func _on_unstable_player_mood_shift(directionMultiplier):
	tween.kill()


func _on_mood_shift_mood_shift_complete(directionMultiplier):
	turnWorld(directionMultiplier)

