extends CollisionShape3D

@export_category("Einstellungen")
@export var bumpPower = 50

signal getBodied(bumpPower, directionNormalized)

func _on_area_3d_body_entered(body):

	if body is UnstablePlayer:
		var directionNormalized = (self.position - body.position).normalized()
		emit_signal("getBodied", bumpPower, directionNormalized)
	
