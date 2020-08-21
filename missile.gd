extends KinematicBody



	
#why does dropping move forward
#get better formula for cl and cd vs alpha
var g = -9.81 #m/s
var speed = 0
var velocity = Vector3(0,0,speed)
var dir = Vector3(0,0,0)
var force = Vector3(0,0,0)

var acc = Vector3(0,0,0)
var CL = 0
var L = 0
var CD = 0
var D = 0
var alpha = 0
var beta = 0
# Called when the node enters the scene tree for the first time.
var vela = Vector3(0,0,0)
	
var weight = 1157 * g
var S_wing = 16.17 #in m2

var T = 0
var am = .7#angular speed
#forces in airplane frame of reference
var N = 0
var A = 0
var S = 0
var G_local = Vector3(0,0,0)
var heading = 0




func _ready():
	yield(get_tree().create_timer(5),"timeout")
	queue_free()


	
		

# warning-ignore:unused_argument
func _process(delta): #change this !
	#$Label.set_text(str(playerID))
	pass
	
	
func _physics_process(delta):

	if 1<2:
		
		var acc = Vector3(0,0,0)
		
		
			
	
		#variation of drag with sideslip?
		#should alpha change when rolling (with an already existing pitch)
		dir = get_transform().basis.z
		#velocity = dir * speed
		
		
		vela = transform.basis.xform_inv(velocity)
		alpha =  atan2(-vela.y, vela.z)
		beta = atan2(vela.x,vela.length())
		if abs(rad2deg(beta)) > 5:
			if beta < 0:
				rotate_object_local(Vector3(0, 1, 0), -delta*am*.3)
			elif beta > 0:
				rotate_object_local(Vector3(0, 1, 0), delta*am*.3)
			
		
		
		
	
	
		
		
	#	given an aircraft representred by 3 axis
	#	and velocity vector. how to find angle of attack
		force = Vector3(0,0,0)	
		
		CL = 0
		
		CD = .025 + pow(abs(rad2deg(alpha)),2)/2300 
		L = .5 * 1.225 * S_wing * velocity.length() * velocity.length()* CL
		D = .5 * 1.225 * S_wing * velocity.length() * velocity.length()* CD
		D = 0
		N = L*cos(alpha) + D*sin(alpha)
		A = D*cos(alpha) - L*sin(alpha)
		A = -A
		A = A + T
		S = 0 #side force. from yaw. aileron not related here
		
		
		
		
		#aileron force is manifested in the global frame
		
		#convert NSA to earth frame
		force = Vector3(S,N,A)
		G_local = -force.y/(weight)  #plus one because formula, other for gravity
		force = transform.basis.xform(force)  #inverse?
		
		#convert forces to acceleratoin
		acc = g*force/weight
		acc.y+=g
		#make acceleration affect velocity (multiply by delta)
		velocity += acc*delta
		
		
		
	
		transform = transform.orthonormalized() 
		
	else: # We are not controlling! This is a representation of this other player
		
		pass
# warning-ignore:return_value_discarded
	move_and_slide(velocity,Vector3(0,1,0))
		
	


