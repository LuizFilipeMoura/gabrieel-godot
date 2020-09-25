extends Area2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var Player = null
var speed = 2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	look_vec = Player.position - get_global_position()
	$Sprite.rotate(look_vec.angle())
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
	if(body.name == "Player"):
		body.hurt(5)
		$Sprite.region_enabled = true
	pass # Replace with function body.
