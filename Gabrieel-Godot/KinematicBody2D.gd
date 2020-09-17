extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
const ACCELERATION = 10
const MAX_SPEED = 150
const JUMP_HEIGHT = -245
const TIME_PERIOD = 0.1 # 500ms

var damage = 1

var isAttacking = false
var time = 0
var LIFE = 3
var motion = Vector2()



func _physics_process(_delta):
	motion.y += GRAVITY
	
	var friction = false
	
	if Input.is_action_pressed("move_left"):
		if Input.is_action_pressed("move_right"):
			motion.x = 0
			friction = true
		else:
			motion.x -=  ACCELERATION
			motion.x = max(motion.x, -MAX_SPEED)
			$AnimatedSprite.flip_h = true
			$AttackRange.transform.origin.x = -15
			if is_on_floor():
				if !isAttacking:
					$AnimatedSprite.play("player_running")
					
		
	elif Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("move_left"):
			motion.x = 0
			friction = true
		else:
			motion.x +=  ACCELERATION
			motion.x = min(motion.x, MAX_SPEED)
			$AnimatedSprite.flip_h = false
			$AttackRange.transform.origin.x = 34
			if is_on_floor():
				if !isAttacking:
					$AnimatedSprite.play("player_running")
	else:
		friction = true
		if is_on_floor():
			if !isAttacking:
				$AnimatedSprite.play("player_idle")
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.4)
	else:
		if !is_on_floor():
			$AnimatedSprite.play("player_jumping")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	motion = move_and_slide(motion, UP)
	
	if Input.is_action_just_pressed("attack"):
		attack()


func knockback(enemy):
	if enemy.position.x > position.x:
		motion.x = -10
	if enemy.position.x < position.x:
		motion.x = 10


func attack():
	if($AnimatedSprite.animation == "player_idle" || $AnimatedSprite.animation == "player_running"):
			isAttacking = true
			$AttackRange/CollisionShape2D.disabled = false
			$AnimatedSprite.play("player_attacking")
			yield($AnimatedSprite, "animation_finished")
			isAttacking = false
			$AttackRange/CollisionShape2D.disabled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	time += delta
	if time > TIME_PERIOD:
		
		# Reset timer
		time = 0
	pass
func smallJump():
	motion.y = (JUMP_HEIGHT/2)
	
func hurt(damageTaken):
	LIFE = LIFE - damageTaken
	if(LIFE <= 0):
		get_tree().change_scene("res://Node2D.tscn")

func _on_Area2D_body_entered(body):
	if(body.name == 'Player'):
		get_tree().change_scene("res://Node2D.tscn")
		
func _on_AttackRange_body_entered(body):
	if(body.is_in_group("Enemy") && isAttacking):
		yield($AnimatedSprite, "animation_finished")
		body.hurt(damage)
