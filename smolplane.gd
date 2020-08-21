extends KinematicBody


	
#why does dropping move forward
#get better formula for cl and cd vs alpha
var g = -9.81 #m/s
var speed = 50
var velocity = Vector3(0,0,speed)
var dir = Vector3(0,0,0)
var force = Vector3(0,0,0)

var wind_vector = Vector3(0,0,0) #wind velocity vector

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

var T = 500
var am = .7#angular speed
#forces in airplane frame of reference
var N = 0
var A = 0
var S = 0
var G_local = Vector3(0,0,0)
var heading = 0


#multiplayer
puppet var slave_transform= Transform()

var cd2 = 0
var ar = 7.2
var tc = 0.12

var acl1 = 15
var a0 = 0
var cd1max = 0
var acd1=15

var f1=0
var f2 = 0
var g1 = 0
var g2 = 0
var cl2max=0
var cd2max = 0
	
var playerID = ""
func _ready():
	translation = Vector3(0,1000,-2000)
	if is_network_master(): 
		$Camera.set_current(true)
		
		
	

	f1 = 1.190 * ( 1 - pow(tc,2) ) 
	f2 = 0.65 + 0.35*pow(2.718,( -pow((9/ar),2.3) ))

	g1 = 2.300 * pow(2.718,(-pow((0.65*0.12),0.90)))
	g2 = 0.52 + 0.48 * pow(2.718,(-pow((6.5/ar),1.1) ))

	cl2max = f1 * f2
	cd2max = g1 * g2

	
	
		

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("ui_reset"): #does this work in multiplayer?
		get_tree().reload_current_scene()
		
	
		
	$"../HUD/fps_count".text = "FPS : " +  str(1/(delta+.001)) #hack to prevent divide by zero
	
var rcl2 = 0
var n2 = 0
var cl2 = 0

func alpha2CL(alpha):
	#  rcl2 : reduction from extension of linear segment of lift curve to cl2max
	rcl2 = 1.632 - cl2max
   # n2 : exponent defining shape of lift curve at cl2max
	n2 = 1 + cl2max/rcl2

   #for negative alpha

	
	if alpha < 0:
		cl2 =  -alpha2CL(-alpha)
	elif 0 <= alpha and alpha < acl1 :
		cl2 = 2*3.14*alpha*3.14/180
	elif acl1 <= alpha and alpha <= 92 :
		cl2 = -0.032*(alpha - 92) - rcl2 * pow(((92-alpha)/51),n2)
	else:
		cl2 = -0.032* (alpha - 92) + rcl2 * pow(((alpha - 92)/51),n2)

   
	return cl2
var angle = 0

func alpha2CD(alpha):
	if (2*a0 - 20) < alpha and alpha < 20 :
		cd2 = .025 + pow(abs(alpha),2)/2300 

	elif alpha >= 20 :
		angle = deg2rad(90* ((alpha-acd1)/(90 - acd1)) )
		cd2 = cd1max + (cd2max - cd1max) * sin(angle)
	  

   # negative angle of attack
	if alpha <= (2*a0 - acd1) :
		cd2 = alpha2CD( -alpha + 2*a0)

	return cd2
var k = 0

func _physics_process(delta):

# warning-ignore:shadowed_variable
# warning-ignore:unused_variable
# warning-ignore:shadowed_variable
	if is_network_master(): 
		
		
		var acc = Vector3(0,0,0)
		if Input.is_action_pressed("ui_pitch_down"): 
			rotate_object_local(Vector3(1, 0, 0), delta*am*.3)
		if Input.is_action_pressed("ui_pitch_up"): 
			rotate_object_local(Vector3(1, 0, 0), -delta*am*.3)
		if Input.is_action_pressed("ui_yaw_left"): 
			rotate_object_local(Vector3(0, 1, 0), delta*am*.7)
		if Input.is_action_pressed("ui_yaw_right"): 
			rotate_object_local(Vector3(0, 1, 0), -delta*am*.7)
		if Input.is_action_pressed("ui_bank_left"): 
			rotate_object_local(Vector3(0, 0, 1), -delta*am)
		if Input.is_action_pressed("ui_bank_right"): 
			rotate_object_local(Vector3(0, 0, 1), delta*am)
		if Input.is_action_pressed("ui_thrust_up"): 
			T+=1000*delta
		if Input.is_action_pressed("ui_thrust_down"): 
			T-=1000*delta
		if Input.is_action_just_pressed("ui_fire"):
			var missile_instance = load("res://missile.tscn").instance()	#dont forget to add yourself  server guy!
			
			missile_instance.velocity = velocity*2
			missile_instance.transform = transform
			missile_instance.rotation = rotation
			
			get_node("/root/Spatial").add_child(missile_instance)
		
		if Input.is_action_just_pressed("ui_debug"): #fix to do for key H
			$"../HUD/debug".visible = not $"../HUD/debug".visible #toggle
		if T < 0:
			T = 0
		
			
	
		#variation of drag with sideslip?
		#should alpha change when rolling (with an already existing pitch)
		dir = get_transform().basis.z
		#velocity = dir * speed
		
		
		vela = transform.basis.xform_inv(velocity - wind_vector)
		alpha =  atan2(-vela.y, vela.z)
		beta = atan2(vela.x,vela.length())
		if abs(rad2deg(beta)) > 5:
			if beta < 0:
				rotate_object_local(Vector3(0, 1, 0), -delta*am*.3)
			elif beta > 0:
				rotate_object_local(Vector3(0, 1, 0), delta*am*.3)
			
	# warning-ignore:return_value_discarded
		
		
		
	
	
		
		
	#	given an aircraft representred by 3 axis
	#	and velocity vector. how to find angle of attack
		force = Vector3(0,0,0)	
		
		CL = alpha2CL(rad2deg(alpha))
		CD = alpha2CD(rad2deg(alpha))
		$"../HUD/debug".text = str(CL) + "\n" + str(CD)
#		CL = 1
#		CD = .1
		
		
		
		
		
		
		
		
		
		
		
		L = .5 * 1.225 * S_wing * velocity.length() * velocity.length()* CL
		D = .5 * 1.225 * S_wing * velocity.length() * velocity.length()* CD
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
		
		
		
		$"../HUD/aoa".text = "AOA\n" + str(rad2deg(alpha)) + "\nBeta\n" + str(rad2deg(beta))

		$"../HUD/airspeed".text = "AIRSPEED\n" + str(velocity.length()) + " m/s"
		$"../HUD/altitude".text = "ALT\n" + str(ceil(translation.y)) + " m"
		$"../HUD/vs".text = "VS\n" + str(stepify(velocity.y,.1)) + " m/s"
		$"../HUD/thrust".text = "THRUST\n" + str(stepify(T,.1)) + " N"
		$"../HUD/gforce".text = str(G_local) + " G"
		$"../HUD/heading".rotation = -atan2(dir.z,dir.x)
		
		if rad2deg(alpha) > 15:
			$"sputnik_beep".stream_paused = false
		else: 
			$"sputnik_beep".stream_paused = true
		
		var prop_speed = 0
		if T > 200:
			prop_speed = 20
		elif T>15:
			prop_speed = 7
			
		$"AnimationPlayer".play("Cube001Action001",0,prop_speed)
#		$"../HUD/blackout".modulate.a = G_local - 4 #should improve after implementing
#		$"../HUD/redout".modulate.a = -G_local  -3  #moments and all
	
		transform = transform.orthonormalized() 
		rset_unreliable("slave_transform", transform) # you on this local machine is telling everyone else's representation of YOU, that YOU are moving		
	else: # We are not controlling! This is a representation of this other player
		
		transform = slave_transform
	velocity = move_and_slide(velocity,Vector3(0,1,0))
# warning-ignore:return_value_discarded
	
		
	
