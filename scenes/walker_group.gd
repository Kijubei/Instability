@tool
extends Node3D

@export_category("Customization")
@export var moveSpeed = 10
@export var groupBumpPower = 50
@export var walkerAmount = 3:
	set(value):
		walkerAmount = value
		if Engine.is_editor_hint():
			updateWalker()

@export var walkerWidth = 1.5

signal getBodiedFromGroup(bumpPower, directionNormalized)

var walkerArray = []
var walkerScene = preload("res://scenes/walker.tscn")

func _ready():
	addAllWalker()

func updateWalker():
	removeAllWalker()
	addAllWalker()

func removeAllWalker():
	for walker in walkerArray:
		walker.queue_free()
	walkerArray = []

func addAllWalker():
	for x in walkerAmount:
		var walker = walkerScene.instantiate()
		add_child(walker)
		walker.transform.origin.x = walkerPosition(x+1)
		walker.bumpPower = groupBumpPower
		walker.moveSpeed = moveSpeed
		walkerArray.append(walker)

func walkerPosition(forX) -> float:
	var equalizer = (walkerWidth * walkerAmount) / 2
	var absolutePosX = forX * walkerWidth
	return absolutePosX - equalizer
