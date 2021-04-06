extends KinematicBody2D

onready var MONEY_SCENE = preload("res://Money.tscn")
var isDead = false;
var life = 2
var damage = 2

signal hurtTank

const UP = Vector2(0,-1)
const GRAVITY = 10
const JUMP_HEIGHT = -245
var motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("enemy_idle")
	if self.name == "Enemy2":
		life = 4 

func _on_Timer_timeout():
	$AnimatedSprite.play("enemy_shot")

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if($CollisionShape2D && !$CollisionShape2D.disabled):
		motion.y += GRAVITY
		if !isDead && is_on_floor():
			motion.x = motion.x *0.7
		if !isDead:
			motion = move_and_slide(motion, UP)

func die():
	emit_signal("hurtTank")
	if($CollisionShape2D):
		get_node("CollisionShape2D").queue_free()
	isDead = true
	$AnimatedSprite.play("enemy_death")
	yield($AnimatedSprite, "animation_finished")
	var money = MONEY_SCENE.instance()
	money.position = Vector2(get_global_position().x+20, get_global_position().y)
	get_parent().add_child(money)
	self.queue_free()
		
	
		
func _on_Head_body_entered(body):
	if(body.name == 'Player'):
		if(!isDead):
			body.smallJump()
			die()
			

func hurt(damageTaken):
	if(!isDead):
		$AnimatedSprite.play("enemy_hurt")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("enemy_idle")
	life = life - damageTaken
	if(life <= 0):
		die()

func _on_Body_body_entered(body):
	if(body.name == 'Player' && !isDead):
		if(body.position.x - position.x):
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		body.knockback(100, self.position.x)
		body.hurt(damage)
		
