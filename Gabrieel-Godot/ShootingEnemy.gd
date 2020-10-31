extends KinematicBody2D

var Player = null
onready var BULLET_SCENE = preload("res://Bullet.tscn")
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
# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_parent().get_parent().get_node("Player")
	$Timer.start(fire_delay)
	$AnimatedSprite.play("idle")

func knockback(amount):
	motion.y = JUMP_HEIGHT*amount
	if ($AnimatedSprite.flip_h):
		motion.x = 100
	else:
		motion.x = -100

func _on_Timer_timeout():
	$Timer.start(fire_delay)
	if ( inRange && !isDead):
		shot()

func _on_AttackRange_body_entered(body):
	if body.name == "Player":
		inRange = true
		
func shot():
	$AnimatedSprite.play("Shoot")
	var bullet = BULLET_SCENE.instance()
	bullet.position = Vector2(get_global_position().x+20, get_global_position().y-10)
	bullet.Player = Player
	bullet.speed = 2
	bullet.damage = 3
	get_parent().add_child(bullet)
	
	
func turnToPlayer():
	var look_vec = Player.position - position
	if look_vec.x > 0:
		$AnimatedSprite.flip_h = false
	else:
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
		
	
		
func _on_Head_body_entered(body):
	if(body.name == 'Player'):
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
	if(!isDead):
		$AnimatedSprite.play("enemy_hurt")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("enemy_idle")
	if(life <= 0):
		die()

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

	pass # Replace with function body.

func _process(delta):
	if !isDead && !is_on_floor() && !isPilot:
		turnToPlayer()
		
func _on_AttackRange_body_exited(body):
	if(body.name == "Player"):
		inRange = false
