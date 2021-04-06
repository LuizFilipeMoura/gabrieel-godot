extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button2_pressed():
	print(Global.trys)
	Global.trys = 30
	get_tree().change_scene("res://Level1.tscn")
	pass # Replace with function body.
