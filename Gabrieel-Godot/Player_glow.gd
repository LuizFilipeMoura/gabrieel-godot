extends Light2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var node = get_tree().get_root().get_node("Node2D/Player")
	position = Vector2(node.position.x + 10, node.position.y)
#	pass
