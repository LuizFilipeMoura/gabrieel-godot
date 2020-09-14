extends KinematicBody2D


# Declare member variables here. Examples:
var isDead = false;




# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("enemy_idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func die():
	isDead = true
	$AnimatedSprite.play("enemy_death")
	yield($AnimatedSprite, "animation_finished")
	$CollisionShape2D.scale = Vector2(1.5, 0.4)
	$CollisionShape2D.position = Vector2(10, 10)
		
func _on_PlayerDetector_body_entered(body):
	if(body.name == 'Player'):
		if(!isDead):
			die()

