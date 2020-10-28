extends Node2D

onready var platform = $Platform
onready var tween = $"Move Tween"
const IDLE_DURATION = 1
export var move_to = Vector2.RIGHT * 192
export var speed = 3


func _ready():
	_init_tween()


func _init_tween():
	var duration = move_to.length() / float (speed * Globals.UNIT_SIZE)
	tween.interpolate_property(plataform, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
