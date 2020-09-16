extends KinematicBody2D



var isDead = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("enemy_idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_collide(Vector2(0, 1))

func die():
	isDead = true
	$AnimatedSprite.play("enemy_death")
	yield($AnimatedSprite, "animation_finished")
	$CollisionShape2D.scale = Vector2(2, 0.2)
	$CollisionShape2D.transform.origin = Vector2(7, 20)
		
func _on_Head_body_entered(body):
	
	if(body.name == 'Player'):
		if(!isDead):
			die()



func _on_Body_body_entered(body):
	if(body.name == 'Player' && !isDead):
			get_tree().change_scene("res://Node2D.tscn")
	pass # Replace with function body.
