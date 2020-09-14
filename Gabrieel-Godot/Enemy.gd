extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("enemy_idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.collider.name)
	pass


func _on_PlayerDetector_body_entered(body):
	if(body.name == 'Player'):
		$AnimatedSprite.play("enemy_death")
		var escala = Vector2(1, 0.5)
		$CollisionShape2D.transform.scaled(escala)
