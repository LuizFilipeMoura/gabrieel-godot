extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal full
signal not_full

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Global.hasPatch :
		self.visible = false
	pass # Replace with function body.



func _on_Player_refreshAnger(anger):
	value = anger
	if value == max_value:
		emit_signal("full")
	else:
		emit_signal("not_full")
	pass # Replace with function body.
