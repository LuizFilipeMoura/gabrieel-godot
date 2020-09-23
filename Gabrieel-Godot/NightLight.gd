extends Light2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func blinkLights():
	var cor = color
	for i in [0,1]:
		var t2 = Timer.new()
		t2.set_wait_time(0.1)
		self.add_child(t2)
		t2.start()
		yield(t2, "timeout")
		color = Color(1.5,0.8,0.8,1)
		var t = Timer.new()
		t.set_wait_time(0.1)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		color = Color(0.5,0.5,0.5,1)
	color = cor
