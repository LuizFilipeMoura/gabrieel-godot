extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
var ACCELERATION = 2
var MAX_SPEED = 300
var motion = Vector2()
var isReadyToMove = false
var isMovingto = "right"
var lookingTime = 0.5
var isDead = false;
var life = 2
var damage = 2
var isPilot = false
signal hurtTank
const JUMP_HEIGHT = -245
# Called when the node enters the scene tree for the first time.
func _ready():
	isReadyToMove = true
	if self.name == "Enemy2":
		life = 4 

func knockback(amount, positionX):
	motion.y = JUMP_HEIGHT*amount
	if positionX > self.position.x:
		$AnimatedSprite.flip_h = false
	if positionX < self.position.x:
		$AnimatedSprite.flip_h = true
	if ($AnimatedSprite.flip_h):
		motion.x = 100
	else:
		motion.x = -100

func stop():
	isReadyToMove = false

func  _on_Timer_timeout():
	if !isDead:
		isReadyToMove = true
	
func _process(delta):
	#motion.y += GRAVITY
	move_and_collide(Vector2(0,10))
	if !isReadyToMove && !isDead:
		$AnimatedSprite.play("enemy_idle")
	if !isReadyToMove:
		motion.x = lerp(motion.x, 0, 0.4)
	if(isReadyToMove && !isDead):
		if(motion.x > 6):
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Enemy_Walk")
		elif (motion.x < -6):
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("Enemy_Walk")
		if isMovingto == "left":
			motion.x -=  ACCELERATION # LEFT
			motion.x = max(motion.x, -MAX_SPEED)
		if isMovingto == "right":
			motion.x +=  ACCELERATION # RIGHT
			motion.x = min(motion.x, MAX_SPEED)
	motion = move_and_slide(motion, UP)
#	pass

func _physics_process(delta):
	if !isDead && !is_on_floor() && !isPilot:
		move_and_collide(Vector2(0, 10))

func die():

	$AnimatedSprite.play("enemy_death")
	isDead = true
	yield($AnimatedSprite, "animation_finished")
	self.queue_free()
		
	
		
func _on_Head_body_entered(body):
	if(body.name == 'Player'):
		if(isPilot):
			body.smallJump()
			emit_signal("hurtTank")
			$AnimatedSprite.play("enemy_death")
			yield($AnimatedSprite, "animation_finished")
		elif(!isDead):
			body.smallJump()
			die()
			

func hurt(damageTaken):
	life = life - damageTaken
	if(life <= 0):
		die()
	else:
		if(!isDead):
			$AnimatedSprite.play("enemy_hurt")
			yield($AnimatedSprite, "animation_finished")
	

func _on_Body_body_entered(body):
	if(body.name == 'Player' && !isDead):
		if(body.position.x - position.x):
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		body.hurt(damage)
		
func isPilot():
	isPilot = true
	$CollisionShape2D.disabled = true

func _on_TurningPointR_body_entered(body):
	if(body.is_in_group("Enemy")):
		stop()
		$Timer.start(lookingTime)
		isMovingto = "left"


func _on_TurningPointL_body_entered(body):
	if(body.is_in_group("Enemy")):
		stop()
		$Timer.start(lookingTime)
		isMovingto = "right"
