extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
signal isitsingle

func _on_single_pressed():
	
	var globe = get_node("/root/global")
	globe.issingle = true
	get_tree().change_scene("res://rivendell.tscn")



	


func _on_exit_pressed():
	get_tree().quit()


func _on_multi_pressed():
	get_tree().change_scene("res://rivendell.tscn")
