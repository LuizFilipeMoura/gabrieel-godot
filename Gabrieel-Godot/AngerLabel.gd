extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureProgress_full():
	text = 'ANGRY!'
	set("custom_colors/font_color",Color(1,0,0))
	pass # Replace with function body.


func _on_TextureProgress_not_full():
	text = 'Anger'
	set("custom_colors/font_color",Color(1,1,1))
	pass # Replace with function body.
