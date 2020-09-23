extends KinematicBody2D



var isDead = false;
var live = 2 
var damage = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("enemy_idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !isDead && !is_on_floor():
		move_and_collide(Vector2(0, 10))

func die():
	isDead = true
	$AnimatedSprite.play("enemy_death")
	yield($AnimatedSprite, "animation_finished")
	$CollisionShape2D.scale = Vector2(2, 0.2)
	if($AnimatedSprite.flip_h == true): 
		$CollisionShape2D.transform.origin = Vector2(-7, 20)
	else:
		$CollisionShape2D.transform.origin = Vector2(7, 20)
	
		
func _on_Head_body_entered(body):
	if(body.name == 'Player'):
		if(!isDead):
			print()
			body.smallJump()
			die()

func hurt(damageTaken):
	live = live - damageTaken
	if(live <= 0):
		die()

func _on_Body_body_entered(body):
	if(body.name == 'Player' && !isDead):
		if(body.position.x - position.x):
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		body.hurt(damage)


