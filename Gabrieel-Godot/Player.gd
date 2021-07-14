extends KinematicBody2D

const UP = Vector2(0,-1)
var GRAVITY = 10
const ACCELERATION = 7

const JUMP_HEIGHT = -245
const TIME_PERIOD = 0.1 # 500ms

var canJump= true
var rng = RandomNumberGenerator.new()
onready var FIREBALL_SCENE = preload("res://Fireball.tscn")


var isJumping = false
var damage = 1
var lifelabelnode
var trylabelnode
var hud
var angerNode
var isAttacking = false
var isHurt = false
var time = 0
var LIFE = 5
var motion = Vector2()
var isAlive = false
var isSpawning = false
var willHurtEnemy = true
var flip = 1;
var hurtable = false
var maxAnger = 50
var fireballAngerNeed = 50
var anger = 0
var volume = -10
var spawnPoint = Vector2(0,0)



signal pickupKey1
signal pickupKey2
signal win
signal refreshAnger
	
func _ready():
	rng.randomize()
	lifelabelnode = get_parent().get_node("HUD/Interface/VBoxContainer/Counter/Label")
	trylabelnode = get_parent().get_node("HUD/Interface/HBoxContainer/TryCounter/Label")
	angerNode = get_parent().get_node("HUD/Interface/HBoxContainer/AngerBar")
	hud = get_parent().get_node("HUD/Interface")
	trylabelnode.text = str(Global.trys)
	spawnPoint = position
	spawn()

func spawn():
	hurtable = false
	if(Global.patchEquiped != ''):
		angerNode.visible = true
		connect("refreshAnger", angerNode.get_node('TextureProgress'),  "_on_Player_refreshAnger" )
	isSpawning = true
	motion = Vector2(0,0)
	position = spawnPoint
	LIFE = Global.maxLIFE
	lifelabelnode.text = str(LIFE)
	$AnimationPlayer.play("player_spawn")
	yield($AnimationPlayer, "animation_finished")
	isAlive = true
	isSpawning = false
	motion.y = -10
	

func _physics_process(delta):
	if is_on_floor():
		isJumping = false
		canJump = true
		hurtable = true
		
	if !is_on_floor():
		coyoteTimer()

	if Input.is_action_just_pressed("jump"):
		if canJump && isAlive && !isHurt:
			jump()
		
	if(is_on_floor() && !isJumping && !isAttacking && isAlive && !isHurt):
		if(motion.x < -1 || motion.x > 1):
			$AnimationPlayer.play("player_running")
		else:
			$AnimationPlayer.play("player_idle")
	
	motion.y += GRAVITY
	if isAttacking:
		motion.x*=0.8
	
	if isAlive && !isSpawning:
		if is_on_floor():
			if Input.is_action_pressed("move_left") && !isHurt:
				if Input.is_action_pressed("move_right"):
					motion.x = lerp(motion.x, 0, 0.5)
				else:
					if(motion.x > 0):
						motion.x = 0
					motion.x -=  ACCELERATION
					motion.x = max(motion.x, -Global.MAX_SPEED)
					$Sprite.flip_h = true
					flip = -1
					$AttackRange.transform.origin.x = -5
							
				
			elif Input.is_action_pressed("move_right") && !isHurt:
				if Input.is_action_pressed("move_left"):
					motion.x = lerp(motion.x, 0, 0.5)
				else:
					if(motion.x < 0):
						motion.x = 0
					motion.x +=  ACCELERATION
					motion.x = min(motion.x, Global.MAX_SPEED)
					$Sprite.flip_h = false
					flip = 1
					$AttackRange.transform.origin.x = 22
			else:
				if is_on_floor():
					if !isAttacking && !isHurt:
						motion.x = motion.x *0.6
					
		else:
			if Input.is_action_pressed("move_left"):
				motion.x -=  ACCELERATION/2
				motion.x = max(motion.x, -Global.MAX_SPEED*0.8)
			if Input.is_action_pressed("move_right"):
				motion.x +=  ACCELERATION/2
				motion.x = min(motion.x, Global.MAX_SPEED*0.8)

		var snap = Vector2.DOWN  if !isJumping else Vector2.ZERO
		motion = move_and_slide_with_snap(motion, snap, UP)
		
		if Input.is_action_just_pressed("attack") && !isHurt:
			attack()
			
	if Input.is_action_pressed("special") && anger >= fireballAngerNeed && !isHurt:
		anger -= fireballAngerNeed
		emit_signal("refreshAnger", anger)
		if Global.patchEquiped == 'fireball':
			throw_fireball()


func jump():
	canJump = false
	isJumping = true
	var my_random_number = rng.randi_range(1, 3)
	match my_random_number:
		1: 
			$Voices/jump1.volume_db = volume
			$Voices/jump1.play()
		2: 
			$Voices/jump2.volume_db = volume
			$Voices/jump2.play()
		3: 
			$Voices/jump3.volume_db = volume
			$Voices/jump3.play()
	$AnimationPlayer.play("player_jumping")
	motion.y = JUMP_HEIGHT

func attack():
	if($AnimationPlayer.current_animation == "player_idle" || $AnimationPlayer.current_animation == "player_running"):
			var my_random_number = rng.randi_range(1, 3)
			match my_random_number:
				1: 
					$Voices/attack1.volume_db = volume
					$Voices/attack1.play()
				2: 
					$Voices/attack2.volume_db = volume
					$Voices/attack2.play()
				3: 
					$Voices/attack3.volume_db = volume
					$Voices/attack3.play()
			isAttacking = true
			$AttackRange/CollisionShape2D.disabled = false
			$AnimationPlayer.play("player_attacking")
			yield($AnimationPlayer, "animation_finished")
			isAttacking = false
			$AttackRange/CollisionShape2D.disabled = true
			
# Called when the node enters the scene tree for the first time.


func throw_fireball():
	isAttacking = true
	if isAlive :
		$AnimationPlayer.play("throw_fireball")
		GRAVITY = 5
		motion.y /=1.1 
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("player_idle")
		GRAVITY = 10
		isAttacking = false

func fire_fireball():
	var fireball = FIREBALL_SCENE.instance()
	fireball.position = Vector2(get_global_position().x+20, get_global_position().y-10)
	fireball.look_vec = Vector2(flip, 0)
	fireball.flip_h = $Sprite.flip_h
	get_parent().add_child(fireball)

func _process(delta):
	if !isAlive && !isSpawning:
		move_and_collide(Vector2(0, 2))
	time += delta
	if time > TIME_PERIOD:
		time = 0
	pass
	
	
func smallJump():
	motion.y = (JUMP_HEIGHT/4)
	motion.x = motion.x/4
	$AnimationPlayer.play("player_jumping")
	
	
func knockback(amount, positionX):
	motion.x = 0
	motion.y = -amount/2
	if positionX > self.position.x:
		$Sprite.flip_h = false
	if positionX < self.position.x:
		$Sprite.flip_h = true
	if ($Sprite.flip_h):
		motion.x = amount
	else:
		motion.x = -amount
		
func blinkLights():
	if get_parent().get_node("Environment/NightLight"):
		var node = get_parent().get_node("Environment/NightLight")
		node.blinkLights()
	
func hurt(damageTaken):
	if isAlive && hurtable:
		LIFE = LIFE - damageTaken
		$Camera2D.shake(1, 10, 5)
		lifelabelnode.text = str(LIFE)
		if(LIFE <= 0):
			lifelabelnode.text = "0"
			if isAlive:
				die()
		else:
			isHurt = true
			var my_random_number = rng.randi_range(1, 3)
			match my_random_number:
				1: 
					$Voices/hurt1.volume_db =  volume
					$Voices/hurt1.play()
				2: 
					$Voices/hurt2.volume_db = volume
					$Voices/hurt2.play()
				3: 
					$Voices/hurt3.volume_db = volume
					$Voices/hurt3.play()
			$AnimationPlayer.play("player_hurt")
			blinkLights()
			yield($AnimationPlayer, "animation_finished")
			isHurt = false
		
func hurtEnemy():
	willHurtEnemy = true

func makeUnvunerable():
	hurtable = false
	
func makeVunerable():
	hurtable = true


func die(animated = true):
	$AnimationPlayer.stop()
	motion.y = 10
	isAlive = false
	Global.trys-=1
	trylabelnode.text = str(Global.trys)
	if(animated):
		$Voices/die.play()
		$AnimationPlayer.play("player_death")
		yield($AnimationPlayer, "animation_finished")
		if(Global.trys<=0):
			get_tree().change_scene("res://GameOver.tscn")
		$DeathTimer.start(2)
	else:
		if(Global.trys<=0):
			get_tree().change_scene("res://GameOver.tscn")
		spawn()
	

func _on_AttackRange_body_entered(body):
	print('a')
	print(body)
	if(body.is_in_group("Enemy") && willHurtEnemy ):
		$Camera2D.shake(0.5, 10, 2)
		body.hurt(damage)


func _on_DeathZone_body_entered(body):
	if(body.name == 'Player'):
		die(false)

func _on_CheckPoint_body_entered(body):
	if(body.name == 'Player'):
		isAlive = false
		$AnimationPlayer.play("break_guitar")
		yield($AnimationPlayer, "animation_finished")
		isAlive = true
		spawnPoint = Vector2 (body.position.x, body.position.y - 20)

func _on_NextLevel_body_entered(body):
	if(body.name == 'Player'):
		get_tree().change_scene("res://Boss.tscn")

func turnSprite(flip):
	if flip:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func _on_Timer_timeout():
	spawn()

func _on_Boss_bossDie():
	Global.hasPatch = true
	Global.patchEquiped = 'fireball'

func coyoteTimer():
	yield(get_tree().create_timer(.3), "timeout")
	canJump = false


func _on_AngerCooldown_timeout():
	if anger < maxAnger:
		anger+=Global.angerRate
		emit_signal("refreshAnger", anger)
		
	pass # Replace with function body.


func _on_Key1_body_entered(body):
	emit_signal("pickupKey1")


func _on_Key2_body_entered(body):
	emit_signal("pickupKey2")
	pass # Replace with function body.
