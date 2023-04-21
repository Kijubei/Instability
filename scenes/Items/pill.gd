extends StaticBody3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotate(Vector3(0,1,0),0.01)


func _on_area_3d_body_entered(body):
	if body is UnstablePlayer:
		if body.pillUI.pills < body.pillUI.max_pills:
			body.gainPill()
			queue_free()
