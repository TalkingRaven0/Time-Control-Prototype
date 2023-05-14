extends RigidBody2D
const record = preload("res://record.gd")

var linear: Vector2
var angular
var state:int = 1
var positions: record = record.new()
var rotations: record = record.new()
var orig_gravity = gravity_scale
var orig_mass = mass

func _ready():
	var player = get_tree().get_root().get_node("MainScene/Player")
	player.connect("stop", self, "_time_stop")
	player.connect("play", self, "_time_play")
	player.connect("rewind", self, "_time_rewind")

func hit(location:Vector2,direction:Vector2):
	apply_impulse(location,direction)
	
func _physics_process(delta):
	if state == 1:
		positions.add(position)
		rotations.add(rotation)
	
func _integrate_forces(body):
	if state == -1:
		mass = 10000
		gravity_scale = 0
		var newpos = positions.pop()
		var newrotation = rotations.pop()
		if newpos != null and newrotation != null:
			print('hehe')
			body.transform = Transform2D(newrotation,newpos)
		else:
			_time_stop()

func _time_stop():
	if not state==0:
		var mult
		if state == 1:
			mult = 1
		else:
			mult = -1
		state = 0
		linear = linear_velocity * mult
		angular = angular_velocity * mult
		call_deferred('set_mode',RigidBody2D.MODE_STATIC)
	
func _time_play():
	mass = orig_mass
	gravity_scale = orig_gravity
	if not state==1:
		state = 1
		linear_velocity = linear
		angular_velocity = angular
		mode = RigidBody2D.MODE_RIGID
	
func _time_rewind():
	print('rewind')
	if not state==-1:
		linear_velocity = linear
		angular_velocity = angular
		state = -1
		mode = RigidBody2D.MODE_RIGID
