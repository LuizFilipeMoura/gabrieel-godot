extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const UP = Vector2(0,-1)
var velocity = Vector2()
var move_speed = 4 * 4


# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	move_and_slide(velocity, UP)
	
	
func _get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right")) 
	velocity.x = move_speed * move_direction
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
