extends Area3D

@export_category("Customization")
@export var moveSpeed = 3

@onready var gameOverLabel = $GameOverLabel


func _process(delta):
	self.position.z -= moveSpeed * delta
	

func _on_body_entered(body):
	if body is UnstablePlayer:
		gameOverLabel.visible = true
		get_tree().call_group("player", "faint")
