extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
var ACCELERATION = 2
var MAX_SPEED = 300

onready var BULLET_SCENE = preload("res://Bullet.tscn")
onready var PILOT_SCENE = preload("res://Enemy.tscn")
var Player = 0
var motion = Vector2()
var isReadyToMove = false
var isMovingto = "right"
var isShooting = false
var countTimesThatTurned = 0
var countFires = 0
var countTimesThatStopped = 0;
var pilot
var maxFires = 4
var inBetweenShots = 0.8
var maxTurns = 1
var maxStopps = 1

var tankWasHurt = false

signal bossHurt
signal bossDie
var life = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_parent().get_node("Player")
	spawn()
	pass # Replace with function body.

func spawn():
	$RammingArea.position.x = 53
	$AnimationPlayer.play("boss_turn_turret")
	yield($AnimationPlayer, "animation_finished")
	isReadyToMove = true

	
func stopAndFire():
	$PilotTimer.stop()
	countTimesThatStopped+=1
	isReadyToMove = false
	countTimesThatTurned = 0
	motion.x = 0
	lookAtPlayer()
	if(countTimesThatStopped>= maxStopps):
		countTimesThatStopped = 0
		spawnPilot()
	else:
		$Timer.start(inBetweenShots)
	
func lookAtPlayer():
	var look_vec = Player.position - position
	if look_vec.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
		
		
func spawnPilot():
	tankWasHurt = false
	$PilotTimer.start(6)
	pilot = PILOT_SCENE.instance()
	if $Sprite.flip_h:
		pilot.position = Vector2(get_global_position().x + 15 , get_global_position().y ) 
	else: 
		pilot.position = Vector2(get_global_position().x - 5 , get_global_position().y ) 
	pilot.get_node("CollisionShape2D").disabled = true
	pilot.connect("hurtTank", self, "_on_Enemy_hurtTank")
	get_parent().add_child(pilot)
	lookAtPlayer()
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#motion.y += GRAVITY
	move_and_collide(Vector2(0,10))
	if !isReadyToMove:
		motion.x = lerp(motion.x, 0, 0.4)
	if(isReadyToMove && !isShooting):
		if(motion.x > 6):
			$RammingArea.position.x = 53
			$Sprite.flip_h = false
			$AnimationPlayer.play("boss_run")
		elif (motion.x < -6):
			$RammingArea.position.x = -2
			$Sprite.flip_h = true
			$AnimationPlayer.play("boss_run")
		else:	
			$AnimationPlayer.play("boss_idle")
		if isMovingto == "left":
			motion.x -=  ACCELERATION # LEFT
			motion.x = max(motion.x, -MAX_SPEED)
		if isMovingto == "right":
			motion.x +=  ACCELERATION # RIGHT
			motion.x = min(motion.x, MAX_SPEED)
		if(countTimesThatTurned >= maxTurns && countFires == 0 ):
			stopAndFire()
	motion = move_and_slide(motion, UP)
#	pass

func fire(): 
	isShooting = true
	$AnimationPlayer.play("boss_shot")
	#$AnimationPlayer.play("boss_idle")
	if countFires < maxFires:
		$Timer.start(inBetweenShots)
	else:
		$Reload.start(2)
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

func releaseBullet():
	countFires +=1
	var bullet = BULLET_SCENE.instance()
	bullet.position = get_global_position()
	bullet.damage = 2
	bullet.Player = Player
	bullet.shakeAmout = [1, 50, 3]
	get_parent().add_child(bullet)

func die():
	emit_signal("bossHurt", 0)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("boss_death")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("bossDie")
	self.queue_free()
	
func anger():
	MAX_SPEED +=50
	ACCELERATION +=1
	maxFires +=1
	inBetweenShots -= 0.2
	$AnimationPlayer.playback_speed +=0.1

func _on_Enemy_hurtTank():
	if (pilot):
		pilot.queue_free()
	tankWasHurt = true
	life -= 1
	if(life<=0):
		die()
	else:	
		anger()
		emit_signal("bossHurt", life)
		$AnimationPlayer.play("boss_hurt")
		yield($AnimationPlayer, "animation_finished")
		if(countFires == 0):
			isReadyToMove = true
	pass # Replace with function body.


func _on_PilotTimer_timeout():
	if(pilot):
		pilot.queue_free()
	if !tankWasHurt && countFires == 0:
		isReadyToMove = true
	pass # Replace with function body.


func _on_Reload_timeout():
	isReadyToMove = true
	pass # Replace with function body.


func _on_RammingArea_body_entered(body):
	if(body.name == 'Player'):
		if body.position.x - position.x > 0 :
			body.turnSprite(true)
			#body.$Sprite.flip_h = true
		else:
			body.turnSprite(false)
		body.hurt(3)

	pass # Replace with function body.
