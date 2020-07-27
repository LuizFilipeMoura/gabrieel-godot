extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 3
const MAX_SPEED = 175
const JUMP_HEIGHT = -350

var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	
	var friction = false
	
	if Input.is_action_pressed("move_left"):
		motion.x -=  ACCELERATION
		motion.x = max(motion.x, -MAX_SPEED)
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("player_running")
		
	elif Input.is_action_pressed("move_right"):
		motion.x +=  ACCELERATION
		motion.x = min(motion.x, MAX_SPEED)
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("player_running")
	else:
		friction = true
		$AnimatedSprite.play("player_idle")
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		if motion.y < 0:
			$AnimatedSprite.play("player_jumping")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	motion = move_and_slide(motion, UP)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
