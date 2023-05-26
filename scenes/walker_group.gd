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
@export var walkerDirection = 180.0:
	set(value):
		walkerDirection = value
		if Engine.is_editor_hint():
			updateDirection(value)

@export var walkerWidth = 1.5

var walkerArray = []
var walkerScene = preload("res://scenes/walker.tscn")
var directionArrowScene = preload("res://scenes/Effects/direction_arrow.tscn")
var arrow: Node3D
#@onready var directionArrow = $DirectionArrow

func _ready():
	addAllWalker()
	if Engine.is_editor_hint():
		arrow = directionArrowScene.instantiate()
		add_child(arrow)

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

func updateDirection(value):
	if arrow != null:
		pass
		#arrow.rotate(Vector3(0,1,0), value) # super "schnelle" rota
		#arrow.
	#var arrow = directionArrowScene.instantiate()
	#add_child(arrow)
	#arrow.rotation.y = value
	
