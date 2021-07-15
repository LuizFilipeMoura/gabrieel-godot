extends TextureProgress

signal full
signal not_full

func _ready():
	if Global.patchEquiped.has(null) :
		self.visible = false
	pass # Replace with function body.



func _on_Player_refreshAnger(anger):
	value = anger
	if value == max_value:
		emit_signal("full")
	else:
		emit_signal("not_full")
	pass # Replace with function body.
