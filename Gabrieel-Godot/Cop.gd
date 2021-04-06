extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Player = null
var life = 30
var isDead = false

const UP = Vector2(0,-1)
const GRAVITY = 10
const JUMP_HEIGHT = -245
var motion = Vector2()
var isAlive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	isAlive = true
	Player = get_parent().get_parent().get_node("Player")
	pass # Replace with function body.

func turnToPlayer():
	var look_vec = Player.position - position
	if look_vec.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
		
func knockback(amount, positionX):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("cop_idle")
	motion.y = JUMP_HEIGHT*amount
	if positionX > self.position.x:
		$Sprite.flip_h = false
	if positionX < self.position.x:
		$Sprite.flip_h = true
		
	if ($Sprite.flip_h):
		motion.x = 100
	else:
		motion.x = -100
	$RecoverTimer.start(1)

func die():
	isAlive = false
	$AnimationPlayer.stop()
	$AnimationPlayer.play("cop_die")
	yield($AnimationPlayer, "animation_finished")
	self.queue_free()
	pass
	
func hurt(damageTaken):
	life = life - damageTaken
	if(life <= 0):
		die()
	
func _physics_process(delta):
	if($CollisionShape2D && !$CollisionShape2D.disabled):
		motion.y += GRAVITY
		if !isDead && is_on_floor():
			motion.x = motion.x *0.7
		if !isDead:
			motion = move_and_slide(motion, UP)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RecoverTimer_timeout():
	if isAlive:
		var anim = $AnimationPlayer.get_animation("run_towards")
		var pos = self.position
		anim.track_insert_key(1, 0, pos)
		if pos.x > 1041:
			$Sprite.flip_h =  true
		if pos.x < 1041:
			$Sprite.flip_h = false
		$AnimationPlayer.play("run_towards")
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("cop_running")
	pass # Replace with function body.


func _on_PlayerDetector_body_entered(body):
	if(body.name == 'Player'):
		body.knockback(300, self.position.x)
		body.hurt(1)
	pass # Replace with function body.


func _on_PlayerDetector2_body_entered(body):
	$AnimationPlayer.play("cop_running")
	$PlayerDetector2.queue_free()
	pass # Replace with function body.
