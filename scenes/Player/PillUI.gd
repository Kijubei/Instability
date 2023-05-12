class_name PillUI
extends Control

@export var pills = 3
@export var max_pills = 6

@onready var pillImg = $Pill

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.size.x = max_pills * pillImg.texture.get_width()
	pillImg.size.x = pills * pillImg.texture.get_width()

func setPills(value):
	value = clamp(value, 0, max_pills)
	pills = value
	pillImg.size.x = value * pillImg.texture.get_width()

func _on_mood_shift_started():
	setPills(pills-1)

func _on_pill_charger_charged():
	setPills(pills+1)
