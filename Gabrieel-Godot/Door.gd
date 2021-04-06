extends KinematicBody2D

var target1washit = false
var target2washit = false
var target3washit = false
var key1waspicked = false
var key2waspicked = false
var playerEntered = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal consumeKeys

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.name == 'Door1' && target1washit:
		open()
	if self.name == 'Door2' && target2washit  && target3washit:
		open()
	

func open():
	$AnimatedSprite.play("door_open")
	yield($AnimatedSprite, "animation_finished")
	$CollisionShape2D.disabled = true
	
func _on_Target_1_wasHit(targetName):
	target1washit = true

func _on_Target_2_wasHit(targetName):
	target2washit = true


func _on_Target_3_wasHit(targetName):
	target3washit = true


func _on_Player_pickupKey1():
	key1waspicked = true


func _on_Player_pickupKey2():
	key2waspicked = true

func _on_Area2D_body_entered(body):
	if(body.name == 'Player'):
		if self.name == 'Door3' && key1waspicked  && key2waspicked:
			open()
			emit_signal("consumeKeys")
		

