extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.isInShop:
		get_tree().paused = true
		$Shop.visible = true
		$Interface.visible = false
	else:
		$Shop.visible = false
		$Interface.visible = true
		
func _input(event):
	if event.is_action_pressed("pause") && !Global.isInShop:
		get_tree().paused = !get_tree().paused
		$Interface.visible = !get_tree().paused
		$PauseMenu.visible = get_tree().paused
	
