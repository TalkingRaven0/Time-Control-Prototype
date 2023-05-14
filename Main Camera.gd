extends Camera2D

var shake_power = 3
export var shake_time = 0.2
var isShake = false
var curPos
var elapsedtime = 0

func _ready():
	randomize()
	curPos = offset

func _process(delta):
	if isShake:
		if elapsedtime<shake_time:
			offset =  Vector2(randf(), randf()) * shake_power
			elapsedtime += delta
		else:
			isShake = false
			elapsedtime = 0
			offset = curPos

func _on_Player_Shoot():
	elapsedtime = 0
	isShake = true
