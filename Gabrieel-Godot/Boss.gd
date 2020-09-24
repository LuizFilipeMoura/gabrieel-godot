extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
const ACCELERATION = 2
const MAX_SPEED = 500


var Player = 0
var motion = Vector2()
var isReadyToMove = false
var isMovingto = "right"

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_parent().get_node("Player")
	spawn()
	pass # Replace with function body.

func spawn():
	$AnimationPlayer.play("boss_turn_turret")
	yield($AnimationPlayer, "animation_finished")

	print('acabou')
	isReadyToMove = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	motion.y += GRAVITY
	#print($AnimationPlayer.current_animation)
	
	
	if(isReadyToMove):
		if(motion.x > 6):
			$AnimationPlayer.play("boss_run")
		elif (motion.x < -6):
			$AnimationPlayer.play("boss_run_FLIP")
		else:	
			$AnimationPlayer.play("boss_idle")
		if isMovingto == "left":
			motion.x -=  ACCELERATION # LEFT
			motion.x = max(motion.x, -MAX_SPEED)
		if isMovingto == "right":
			motion.x +=  ACCELERATION # RIGHT
			motion.x = min(motion.x, MAX_SPEED)
		
		
	motion = move_and_slide(motion, UP)
#	pass


func _on_TurningPoint_body_entered(body):
	if(body.name == "Boss"):
		isMovingto = "left"

func _on_TurningPoint2_body_entered(body):
	if(body.name == "Boss"):
		isMovingto = "right"



