extends KinematicBody2D

var target1washit = false
var target2washit = false
var target3washit = false
var key1waspicked = false
var key2waspicked = false
var playerEntered = false
var targetsHitted = []
var targetsRequireds = []
var targetResponse = []
var keysRequireds
# var a = 2
# var b = "text"



signal consumeKeys

# Called when the node enters the scene tree for the first time.

func _ready():
	if self.name == 'Door1':
		targetsRequireds = ['Target_1']
	if self.name == 'Door2':
		targetsRequireds = ['Target_2', 'Target_3']
	pass # Replace with function body.

func open():
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	$AnimatedSprite.play("door_open")
	yield($AnimatedSprite, "animation_finished")
	$CollisionShape2D.disabled = true
	
func _on_Target_1_wasHit(targetName):
	if targetsRequireds.has(targetName):
		open()

func _on_Target_2_wasHit(targetName):
	if targetsRequireds.has(targetName):
		targetsHitted.append(targetName)
		targetResponse.append(true)
	if !targetResponse.has(false) && targetResponse.size() == targetsRequireds.size():
		open()


func _on_Target_3_wasHit(targetName):
	if targetsRequireds.has(targetName):
		targetsHitted.append(targetName)
		targetResponse.append(true)
	if !targetResponse.has(false) && targetResponse.size() == targetsRequireds.size():
		open()


func _on_Player_pickupKey1():
	key1waspicked = true


func _on_Player_pickupKey2():
	key2waspicked = true

func _on_Area2D_body_entered(body):
	if(body.name == 'Player'):
		if self.name == 'Door3' && key1waspicked && key2waspicked:
			
			open()
			emit_signal("consumeKeys")
		



func _on_Boss_bossDie():
	open()
