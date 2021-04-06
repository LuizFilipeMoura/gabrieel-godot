extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Buy2_pressed():
	if Global.money>=60:
		Global.money-=60
		Global.angerRate = 1.2
		self.text = "Bought"
	else: 
		self.text = "NOT ENOUGH CASH"
	self.disabled = true
	pass # Replace with function body.
