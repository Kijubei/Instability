class_name PlayerEnergy
extends ProgressBar

@export var runEnergyDrain = 4
@export var boostPower = 8

@onready var restTimer = $RestTimer
@onready var boostTimer = $BoostTimer

var exhausted = false
var boosted = false

func useToRun():
	if exhausted:
		return
	
	if boosted:
		recover()
		return
	
	if value - (step * runEnergyDrain) <= 0:
		exhaust()
	else: 
		value -= step * runEnergyDrain
	

func recover():
	if exhausted:
		return
	
	if boosted:
		value += step * boostPower
	else:
		value += step
		

func boostEnergy():
	exhausted = false
	boosted = true
	restTimer.stop()
	boostTimer.start()

func exhaust():
	exhausted = true
	value = 0
	restTimer.start()

func _on_rest_timer_timeout():
	exhausted = false

func _on_boost_timer_timeout():
	boosted = false
