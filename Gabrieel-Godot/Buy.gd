extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Buy_pressed():
	if Global.money>=70:
		Global.money-=70
		Global.MAX_SPEED = Global.MAX_SPEED * 1.1
		self.text = "Bought"
	else: 
		self.text = "NOT ENOUGH CASH"
	self.disabled = true
		
	pass # Replace with function body.
