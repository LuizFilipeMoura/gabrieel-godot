extends Node


# Declare member variables here. Examples:
# var a = 
# var b = "text"
var trys = 30
var hasPatch = false
var patchEquiped = ''
var money = 0
var isInShop = false
var current_scene = null
var MAX_SPEED = 150
var angerRate = 1
var maxLIFE = 5
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
