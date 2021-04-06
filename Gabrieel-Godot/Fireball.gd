extends Area2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var speed = 3.5
var damage = 5
var flip_h = false
var hasVanished = false
var hasHit = false
# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node("Player").get_node("Camera2D").shake(0.5, 5, 5)
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
	if (!hasVanished):
		if(body.is_in_group("Enemy") || body.name ==  "TileMap"):
			hasHit = true
			if(body.is_in_group("Enemy")):
				body.knockback(0.5, self.position.x)
				body.hurt(damage)
			self.queue_free()
 # Replace with function body.




func _on_Timer_timeout():
	hasVanished = true
	if !hasHit:
		$AnimatedSprite.play("vanish")
	pass # Replace with function body.


func _on_AudioStreamPlayer_finished():
	self.queue_free()
	pass # Replace with function body.
