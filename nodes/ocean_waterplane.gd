extends MeshInstance

var camera
var value = 0
export(float) var ocean_height = 0.0

func _ready():
	camera = get_node("../1/Camera")

# warning-ignore:unused_argument
func _physics_process(delta):
	pass
