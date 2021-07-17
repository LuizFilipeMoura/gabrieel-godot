extends KinematicBody2D

var Player = null
onready var BULLET_SCENE = preload("res://Bullet.tscn")
onready var MONEY_SCENE = preload("res://Money.tscn")
var isDead = false;
var life = 2
var damage = 2
var isPilot = false
var fire_delay = 2
signal hurtTank
var inRange = false
const UP = Vector2(0,-1)
const GRAVITY = 10
const JUMP_HEIGHT = -245
var motion = Vector2()
var firstShot = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_parent().get_parent().get_node("Player")
	$AnimatedSprite.play("idle")

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

func _on_Timer_timeout():
	$Timer.start(fire_delay)
	if ( inRange && !isDead):
		shot()

func _on_AttackRange_body_entered(body):
	if body.is_in_group("Player"):
		if !firstShot:
			shot()
			firstShot = true
		inRange = true
		$Timer.start(fire_delay)
	
func shot():
	if inRange:
		$AnimatedSprite.play("Shoot")
		var bullet = BULLET_SCENE.instance()
		bullet.position = Vector2($Gun.get_global_position().x, $Gun.get_global_position().y)
		bullet.scale = Vector2(0.8, 0.6)
		bullet.Player = Player
		bullet.speed = 2.5
		bullet.damage = 2
		bullet.shakeAmout = [0.5, 5, 2]
		get_parent().add_child(bullet)
		yield(get_node("AnimatedSprite"), "animation_finished")
		$AnimatedSprite.play("idle")
	
func turnToPlayer():
	var look_vec = Player.position - position
	if look_vec.x > 0:
		$Gun.position = Vector2(18, -6)
		$LineOfSight.position = Vector2(70, -17)
		$LineOfSight.rotation = 1.7
		$AnimatedSprite.flip_h = false
	else:
		$LineOfSight.position = Vector2(-70, -17)
		$LineOfSight.rotation = -1.7
		$Gun.position = Vector2(-18, -6)
		$AnimatedSprite.flip_h = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !isDead && !is_on_floor() && !isPilot:
		move_and_collide(Vector2(0, 10))

func die():
	$AnimatedSprite.stop()
	get_node("CollisionShape2D").queue_free()
	isDead = true
	$AnimatedSprite.play("enemy_death")
	yield($AnimatedSprite, "animation_finished")
	self.queue_free()
	var money = MONEY_SCENE.instance()
	money.position = Vector2(get_global_position().x+20, get_global_position().y)
	get_parent().add_child(money)	
	
		
func _on_Head_body_entered(body):
	if(body.name == 'Player'):if(body.name == 'Player'):
		if(isPilot):
			body.smallJump()
			emit_signal("hurtTank")
			$AnimatedSprite.play("enemy_death")
			yield($AnimatedSprite, "animation_finished")
			$AnimatedSprite.play("enemy_idle")
		elif(!isDead):
			body.smallJump()
			die()
			

func hurt(damageTaken):
	life = life - damageTaken

	if(life <= 0):
		die()
	
	if(!isDead):
		$AnimatedSprite.play("enemy_hurt")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("enemy_idle")
	

func _on_Body_body_entered(body):
	if(body.name == 'Player' && !isDead):
		if(body.position.x - position.x):
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		body.knockback(100, self.position.x)
		body.hurt(damage)
		
func isPilot():
	isPilot = true
	$CollisionShape2D.disabled = true

	pass # Replace with function body.

#func _process(delta):
	#if !isDead && !is_on_floor() && !isPilot:
		#turnToPlayer()
		
func _on_AttackRange_body_exited(body):
	if(body.name == "Player"):
		inRange = false


func _on_Line_of_sight_body_entered(body):
	if body.is_in_group("Player"):
		inRange = true
		$Timer.start(fire_delay)


func _on_VisionArea_body_entered(body):
	turnToPlayer()
	pass # Replace with function body


func _on_LineOfSight_body_exited(body):
	if body.is_in_group("Player"):
		if !firstShot:
			shot()
			firstShot = true
		inRange = false
	pass # Replace with function body.
