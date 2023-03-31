extends Node3D


signal getBodiedFromPeople(bumpPower, directionNormalized)

func _on_fugnger_gruppe_get_bodied_from_group(bumpPower, directionNormalized):
	emit_signal("getBodiedFromPeople", bumpPower, directionNormalized)


func _on_fugnger_gruppe_2_get_bodied_from_group(bumpPower, directionNormalized):
	emit_signal("getBodiedFromPeople", bumpPower, directionNormalized)


func _on_fugnger_gruppe_3_get_bodied_from_group(bumpPower, directionNormalized):
	emit_signal("getBodiedFromPeople", bumpPower, directionNormalized)


func _on_fugnger_gruppe_4_get_bodied_from_group(bumpPower, directionNormalized):
	emit_signal("getBodiedFromPeople", bumpPower, directionNormalized)


func _on_fugnger_gruppe_5_get_bodied_from_group(bumpPower, directionNormalized):
	emit_signal("getBodiedFromPeople", bumpPower, directionNormalized)
