extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.






func _on_Button_pressed():
	get_tree().change_scene("res://rivendell.tscn")


func _on_exit_pressed():
	get_tree().quit()
