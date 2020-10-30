extends Area2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var speed = 3
var damage = 5
var flip_h = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.flip_h = flip_h
	pass # Replace with function body.

func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Fireball_body_entered(body):
	if(body.is_in_group("Enemy") || body.name ==  "TileMap"):
		if(body.is_in_group("Enemy")):
			body.hurt(damage)
		self.queue_free()

	pass # Replace with function body.
