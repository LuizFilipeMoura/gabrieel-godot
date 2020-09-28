extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
const ACCELERATION = 2
const MAX_SPEED = 500

onready var BULLET_SCENE = preload("res://Bullet.tscn")
#onready var PILOT_SCENE = preload("res://Enemy.tscn")
var Player = 0
var motion = Vector2()
var isReadyToMove = false
var isMovingto = "right"
var isShooting = false
var countTimesThatTurned = 0
var countFires = 0
var countTimesThatStopped = 0;
var pilot = null

signal bossHurt
signal bossDie
var life = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_parent().get_node("Player")
	spawn()
	pass # Replace with function body.

func spawn():
	$RammingArea.position.x = 0
	$AnimationPlayer.play("boss_turn_turret")
	yield($AnimationPlayer, "animation_finished")
	isReadyToMove = true
	
func stopAndFire():
	countTimesThatStopped+=1
	isReadyToMove = false
	countTimesThatTurned = 0
	motion.x = 0
	isReadyToMove = false
	lookAtPlayer()
	if(countTimesThatStopped>=2):
		countTimesThatStopped = 0
		spawnPilot()
	else:
		$Timer.start(1)
	
func lookAtPlayer():
	var look_vec = Player.position - position
	if look_vec.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
		
		
func spawnPilot():
	lookAtPlayer()
	pilot = get_parent().get_node("Enemy")
	pilot.position = Vector2(get_global_position().x + 10, get_global_position().y - 10) 
	pilot.isPilot()

	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#motion.y += GRAVITY
	move_and_collide(Vector2(0,10))
	if !isReadyToMove:
		motion.x = lerp(motion.x, 0, 0.4)
	if(isReadyToMove && !isShooting):
		$Sprite.flip_h = false
		if(motion.x > 6):
			$RammingArea.position.x = 0
			$AnimationPlayer.play("boss_run")
		elif (motion.x < -6):
			$RammingArea.position.x = -55
			$AnimationPlayer.play("boss_run_FLIP")
		else:	
			$AnimationPlayer.play("boss_idle")
		if isMovingto == "left":
			motion.x -=  ACCELERATION # LEFT
			motion.x = max(motion.x, -MAX_SPEED)
		if isMovingto == "right":
			motion.x +=  ACCELERATION # RIGHT
			motion.x = min(motion.x, MAX_SPEED)
		if(countTimesThatTurned >= 3 && countFires == 0 ):
			stopAndFire()
	motion = move_and_slide(motion, UP)
#	pass

func fire(): 
	countFires +=1
	isShooting = true
	$AnimationPlayer.play("boss_shot")
	var bullet = BULLET_SCENE.instance()
	bullet.position = get_global_position()
	bullet.Player = Player
	yield($AnimationPlayer, "animation_finished")
	get_parent().add_child(bullet)
	$AnimationPlayer.play("boss_idle")
	
	if countFires < 3:
		$Timer.start(1.5)
	else:
		isReadyToMove = true
		countFires = 0
	isShooting = false
	

func _on_TurningPoint_body_entered(body):
	if(body.name == "Boss"):
		countTimesThatTurned +=1
		isMovingto = "left"

func _on_TurningPoint2_body_entered(body):
	if(body.name == "Boss"):
		countTimesThatTurned +=1
		isMovingto = "right"


func _on_Timer_timeout():
	fire()
	pass # Replace with function body.

func die():
	pilot.position = Vector2(315, 52)
	$AnimationPlayer.play("boss_death")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("bossDie")
	self.queue_free()
	emit_signal("bossHurt", 0)
	get_parent().get_node("CanvasLayer/Label").text = ' '
	get_parent().get_node("Enemy").queue_free()
	
	
func _on_Enemy_hurtTank():
	life -= 1
	if(life<=0):
		die()
	else:	
		emit_signal("bossHurt", life)
		pilot.position = Vector2(315, 52)
		$AnimationPlayer.play("boss_hurt")
		yield($AnimationPlayer, "animation_finished")
		isReadyToMove = true
	pass # Replace with function body.
