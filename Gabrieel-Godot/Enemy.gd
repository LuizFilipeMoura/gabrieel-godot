extends KinematicBody2D

var isDead = false;
var life = 2
var damage = 2
var isPilot = false
signal hurtTank

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AnimatedSprite.play("enemy_idle")
	if self.name == "Enemy2":
		life = 4 

func _on_Timer_timeout():
	$AnimatedSprite.play("enemy_shot")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !isDead && !is_on_floor() && !isPilot:
		move_and_collide(Vector2(0, 10))

func die():
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
		body.hurt(damage)
		
func isPilot():
	isPilot = true
	$CollisionShape2D.disabled = true



	pass # Replace with function body.
