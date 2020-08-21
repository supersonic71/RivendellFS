extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	#local angles
	if Input.is_key_pressed(KEY_W):
		rotate_object_local(Vector3(1, 0, 0), -delta*1)
	if Input.is_key_pressed(KEY_S):
		rotate_object_local(Vector3(1, 0, 0), +delta*1)
	if Input.is_key_pressed(KEY_Q):
		rotate_object_local(Vector3(0, 1, 0), delta*1)
	if Input.is_key_pressed(KEY_E):
		rotate_object_local(Vector3(0, 1, 0), -delta*1)
	if Input.is_key_pressed(KEY_A):
		rotate_object_local(Vector3(0, 0, 1), delta*1)
	if Input.is_key_pressed(KEY_D):
		rotate_object_local(Vector3(0, 0, 1), -delta*1)
		
	#global angles
#	if Input.is_key_pressed(KEY_W):
#		rotate_x(-delta)
#	if Input.is_key_pressed(KEY_S):
#		rotate_x(delta)
#	if Input.is_key_pressed(KEY_Q):
#		rotate_y(delta)
#	if Input.is_key_pressed(KEY_E):
#		rotate_y(-delta)
#	if Input.is_key_pressed(KEY_A):
#		rotate_z(delta)
#	if Input.is_key_pressed(KEY_D):
#		rotate_z(-delta)
		
	transform = transform.orthonormalized() #apply only if there is change in orientaiton
