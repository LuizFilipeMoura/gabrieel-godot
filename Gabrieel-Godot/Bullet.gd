extends Area2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var Player = null
var speed = 4
var damage = 5
var shakeAmout = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var camera = Player.get_node("Camera2D")
	look_vec = Player.position - get_global_position()
	$Sprite.rotate(look_vec.angle())
	camera.shake(shakeAmout[0], shakeAmout[1], shakeAmout[2])
	pass # Replace with function body.

func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Bullet_body_entered(body):
	if( body.name ==  "TileMap"|| body.name == "Player"):
		if(body.name == "Player"):
			body.knockback(100, self.position.x)
			body.hurt(damage)
		self.queue_free()

	pass # Replace with function body.
