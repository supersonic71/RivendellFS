extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(input_event):
	
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = !get_tree().paused
	elif Input.is_action_just_pressed("ui_show_control"):
		$"../control".visible = not $"../control".visible
		
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
