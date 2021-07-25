extends KinematicBody2D

var playerEntered = false
var targetsHitted = []
export var targetsRequireds = []
var targetResponse = []
export var keysRequireds = []
var keysAcquired = []
# var a = 2
# var b = "text"



signal consumeKeys

# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.

func open():
	if keysRequireds.size() >= 1:
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
	keysAcquired.append(true)


func _on_Player_pickupKey2():
	keysAcquired.append(true)

func _on_Area2D_body_entered(body):
	if(body.name == 'Player') && self.name == 'Door3' && keysAcquired.size() == keysRequireds.size():
		open()
		emit_signal("consumeKeys")

func _on_Boss_bossDie():
	open()
