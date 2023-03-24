extends Node3D

@export_category("Rotation")
@export var targetAngle = 90
@export var roationSpeed = 0.05

#var tween: Tween

#### TWEEN
# Tweens können alle möglichen animation interpolieren. besonders gut um Sachen nacheinander / parallel zu machen über einen Zeitraum

#### lerp
# Mit lerp kann man bis zu einem gewünschten Winkel mit gewünschter Geschwindigkeit drehen.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#tween = Tween()
	#add_child(tween)
	#tween = get_tree().create_tween()
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "rotation:z", 0.2 , 10)
	#tween.tween_property(self, "rotation:z", -0.2 , 10)

	#tween.tween_callback(self.queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#rotation.z = lerp_angle(rotation.z, targetAngle, delta * roationSpeed)
	#tween.interpolate_value(self, "rotation:z", rotation.z, 5, Tween.TRANS_LINEAR, Tween.EASE_IN)

#func _on_timer_timeout():
	#self.transform = self.transform.rotated(Vector3(0,0,1), 0.001)
	#self.rotate(Vector3(0,0,1), 0.01)
	#self.rotation_degrees
	
