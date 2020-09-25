extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
const ACCELERATION = 10
const MAX_SPEED = 150
const JUMP_HEIGHT = -245
const TIME_PERIOD = 0.1 # 500ms

var damage = 1
var labelnode
var isAttacking = false
var isHurt = false
var time = 0
var LIFE = 5
var motion = Vector2()
var isAlive = false
var isSpawning = false

var spawnPoint = Vector2(0,0)


func _physics_process(_delta):

	motion.y += GRAVITY
	
	if isAlive && !isSpawning:
		var friction = false
		if is_on_floor():
			if Input.is_action_pressed("move_left"):
				if Input.is_action_pressed("move_right"):
					motion.x = 0
					friction = true
					$AnimationPlayer.play("player_idle")
				else:
					motion.x -=  ACCELERATION
					motion.x = max(motion.x, -MAX_SPEED)
					$Sprite.flip_h = true
					$AttackRange.transform.origin.x = -5
					if is_on_floor():
						if !isAttacking && !isHurt && motion.x != 0:
							$AnimationPlayer.play("player_running")
							
				
			elif Input.is_action_pressed("move_right"):
				if Input.is_action_pressed("move_left"):
					motion.x = 0
					friction = true
					$AnimationPlayer.play("player_idle")
				else:
					motion.x +=  ACCELERATION
					motion.x = min(motion.x, MAX_SPEED)
					$Sprite.flip_h = false
					$AttackRange.transform.origin.x = 22
					if is_on_floor():
						if !isAttacking && !isHurt && motion.x != 0:
							$AnimationPlayer.play("player_running")
			else:
				friction = true
				if is_on_floor():
					if !isAttacking && !isHurt:
						$AnimationPlayer.play("player_idle")
					
		else:
			if Input.is_action_pressed("move_left"):
				motion.x -=  ACCELERATION/2
				motion.x = max(motion.x, -MAX_SPEED*0.8)
			if Input.is_action_pressed("move_right"):
				motion.x +=  ACCELERATION/2
				motion.x = min(motion.x, MAX_SPEED*0.8)

		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				jump()
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.4)
		motion = move_and_slide(motion, UP)
		
		if Input.is_action_just_pressed("attack"):
			attack()


func jump():
	$AnimationPlayer.play("player_jumping")
	motion.y = JUMP_HEIGHT

func attack():
	if($AnimationPlayer.current_animation == "player_idle" || $AnimationPlayer.current_animation == "player_running"):
			isAttacking = true
			$AttackRange/CollisionShape2D.disabled = false
			$AnimationPlayer.play("player_attacking")
			yield($AnimationPlayer, "animation_finished")
			isAttacking = false
			$AttackRange/CollisionShape2D.disabled = true
			
# Called when the node enters the scene tree for the first time.
func _ready():
	labelnode = get_parent().get_node("CanvasLayer/Interface/VBoxContainer/Counter/Label")
	spawnPoint = position
	spawn()
	pass # Replace with function body.

func spawn():
	isAlive = true
	isSpawning = true
	motion = Vector2(0,0)
	position = spawnPoint
	LIFE = 5
	labelnode.text = str(LIFE)
	$AnimationPlayer.play("player_spawn")
	yield($AnimationPlayer, "animation_finished")
	isSpawning = false
	motion.y = -100
	
	


func _process(delta):
	if !isAlive && !isSpawning:
		move_and_collide(Vector2(0, 2))
	time += delta
	if time > TIME_PERIOD:
		time = 0
	pass
	
	
func smallJump():
	motion.y = (JUMP_HEIGHT/2)
	motion.x = motion.x/4
	$AnimationPlayer.play("player_jumping")
	
	
func knockback():
	motion.y = JUMP_HEIGHT/2
	if ($Sprite.flip_h):
		motion.x = 150
	else:
		motion.x = -150
		
func blinkLights():
	var node = get_tree().get_root().get_node("Level1/Environment/NightLight")
	node.blinkLights()
	
func hurt(damageTaken):
	LIFE = LIFE - damageTaken
	labelnode.text = str(LIFE)
	if(LIFE <= 0):
		labelnode.text = "0"
		die()
	else:
		isHurt = true
		$AnimationPlayer.play("player_hurt")
		knockback()
		blinkLights()
		yield($AnimationPlayer, "animation_finished")
		isHurt = false
		
		
func die(animated = true):
	motion.y = 10
	
	isAlive = false
	if(animated):
		$AnimationPlayer.play("player_death")
		yield($AnimationPlayer, "animation_finished")
		spawn()
	else:
		spawn()

	
		
func _on_AttackRange_body_entered(body):
	if(body.is_in_group("Enemy") && isAttacking):
		yield($AnimationPlayer, "animation_finished")
		body.hurt(damage)


func _on_DeathZone_body_entered(body):
	if(body.name == 'Player'):
		die(false)
		

func _on_CheckPoint_body_entered(body):
	if(body.name == 'Player'):
		spawnPoint = Vector2 (body.position.x, body.position.y - 20)

func _on_NextLevel_body_entered(body):
	if(body.name == 'Player'):
		get_tree().change_scene("res://Boss.tscn")
