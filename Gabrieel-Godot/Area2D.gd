extends Area2D

onready var body = get_node("Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func body_enter(body):
	print(body.get_name())

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
