extends RigidBody2D

# signals
signal Shoot
signal damaged
signal stop
signal play
signal rewind

# stats
var recoil : int = 300

# physics
var speed : int = 200
var jumpForce : int = 500
var gravity : int = 800
var vel : Vector2 = Vector2()
var ext_force : Vector2 = Vector2()

# Player State Variables
var shoot_cd : int = 15
var shoot_timer : int = 0
var shooting : bool = false
var look_right : bool = true
var direction : int = 1
var grounded : bool = false
var moving : bool = false

# components
onready var sprite = $Anim
onready var muzzle = $muzzle
onready var pew:RayCast2D = $RayCast2D
onready var ground:RayCast2D = $ground

func _ready():
	friction = 0.5

# Main Process
func _physics_process (delta):
	handle_variables(delta)
	
	movement_inputs()
	
	time_inputs()
	
	update_sprite()
	
func _integrate_forces(state):
	move_character()

# Sub Processes
func _draw():
	draw_guide()

func time_inputs():
	if Input.is_action_just_pressed("play"):
		emit_signal("play")
	elif Input.is_action_just_pressed("stop"):
		emit_signal("stop")
	elif Input.is_action_just_pressed("rewind"):
		emit_signal("rewind")

func movement_inputs():
	if shooting:
		return
	
	# movement inputs
	if Input.is_action_just_pressed("move_left"):
		add_force(Vector2.ZERO,Vector2.LEFT*speed)
		look_right = false
		moving = true
		
	if Input.is_action_just_released("move_left"):
		add_force(Vector2.ZERO,Vector2.RIGHT*speed)
		moving = false
	
	if Input.is_action_just_pressed("move_right"):
		add_force(Vector2.ZERO,Vector2.RIGHT*speed)
		look_right = true
		moving = true
		
	if Input.is_action_just_released("move_right"):
		add_force(Vector2.ZERO,Vector2.LEFT*speed)
		moving = false

		
	if Input.is_action_just_pressed("shoot"):
		emit_signal("Shoot")
	
	# jump input
	if Input.is_action_pressed("jump") and ground.is_colliding():
		apply_central_impulse(Vector2.UP*jumpForce)

func handle_variables(delta):
	if shoot_timer > 0:
		shoot_timer -= delta
		shooting = true
	else:
		shooting = false
	
	if look_right:
		direction = 1
	else:
		direction = -1

func update_sprite():
	if shooting:
		sprite.play("Shoot")
		return

	# sprite direction
	sprite.flip_h = not look_right
	
	if ground.is_colliding():
		if !moving:
			sprite.play("Idle")
		else:
			sprite.play("Walk")
		
	if not ground.is_colliding():
		sprite.play("Jump")
	

func move_character():
	pass

func draw_guide():
	draw_line(Vector2.ZERO,Vector2(999,0),Color(255,255,255,0.0001),5)
	draw_line(Vector2.ZERO,Vector2(-999,0),Color(255,255,255,0.0001),5)
	pass

# Signal Listeners
func _on_Player_Shoot():
	muzzle.scale.x = abs(muzzle.scale.x) * direction
	ext_force.x += recoil * -direction
	shoot_timer = shoot_cd
	muzzle.visible = true
	muzzle.play("default")
	
	pew.enabled = true
	pew.cast_to = Vector2(999*direction,0)
	pew.force_raycast_update()
	if !pew.is_colliding():
		pew.enabled = false
		return
	var collider = pew.get_collider()
	if collider.has_method("hit"):
		var point = pew.get_collision_point()
		collider.hit(point-collider.get_global_position(), Vector2(200*direction,0))
	pew.enabled = false

func _on_muzzle_animation_finished():
	if muzzle.animation == "default":
		muzzle.stop()
		muzzle.visible = false
