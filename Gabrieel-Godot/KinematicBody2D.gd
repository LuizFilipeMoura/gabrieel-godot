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
				$AttackRange.transform.origin.x = -15
				if is_on_floor():
					if !isAttacking && motion.x != 0:
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
				$AttackRange.transform.origin.x = 34
				if is_on_floor():
					if !isAttacking && motion.x != 0:
						$AnimationPlayer.play("player_running")
		else:
			friction = true
			if is_on_floor():
				if !isAttacking:
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
			$AnimationPlayer.play("player_jumping")
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.4)
	else:
		#if !is_on_floor():
			#print('a')
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	motion = move_and_slide(motion, UP)
	
	if Input.is_action_just_pressed("attack"):
		attack()


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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	var node = get_tree().get_root().get_node("Node2D/NightLight")
	var cor = node.color
	for i in [0,1]:
		var t2 = Timer.new()
		t2.set_wait_time(0.1)
		self.add_child(t2)
		t2.start()
		yield(t2, "timeout")
		node.color = Color(0.6,0.2,0.2,1)
		var t3 = Timer.new()
		t3.set_wait_time(0.1)
		self.add_child(t3)
		t3.start()
		yield(t3, "timeout")
		node.color = Color(0.5,0.5,0.5,1)
		var t = Timer.new()
		t.set_wait_time(0.1)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		node.color = Color(0.1,0.1,0.1,1)
	node.color = cor
	
func hurt(damageTaken):
	knockback()
	blinkLights()
	LIFE = LIFE - damageTaken
	if(LIFE <= 0):
		get_tree().change_scene("res://Node2D.tscn")
		

func _on_Area2D_body_entered(body):
	if(body.name == 'Player'):
		get_tree().change_scene("res://Node2D.tscn")
		
		
func _on_AttackRange_body_entered(body):
	if(body.is_in_group("Enemy") && isAttacking):
		yield($AnimationPlayer, "animation_finished")
		body.hurt(damage)
