extends Area2D

onready var body = get_node("Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal wasHit

func body_enter(body):
	print('a')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	if(area.is_in_group('Fireball')):
		$AnimatedSprite.play("target_hit")
		yield($AnimatedSprite, "animation_finished")
		emit_signal("wasHit", self.name);
	pass # Replace with function body.
