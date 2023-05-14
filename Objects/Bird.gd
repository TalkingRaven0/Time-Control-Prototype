extends KinematicBody2D

var move_dir
var speed = 200
onready var player = get_node("../MainScene/Player")
onready var sprite = $Anim

func _physics_process(delta):
	move_dir = Vector2(player.position.x - position.x, player.position.y - position.y).normalized()
	
	move_dir.y *= .50
	
	if move_dir.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	move_and_slide(move_dir*speed)
