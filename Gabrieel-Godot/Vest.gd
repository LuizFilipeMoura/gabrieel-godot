extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.patchEquiped[0] == 'fireball':
		$Button.visible = true
	if Global.patchEquiped[1] == 'fireball':
		$Button2.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
