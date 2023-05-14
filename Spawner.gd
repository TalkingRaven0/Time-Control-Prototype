extends Node2D

onready var spawnEffect = $AnimatedSprite

var targ_monster
var counter
var bufferlength = 2

func _ready():
	var main = get_node("../")
	main.connect("spawn", self, "_on_MainScene_spawn")

func spawn_monster():
	targ_monster.position=position
	get_tree().get_root().add_child(targ_monster)

func _on_MainScene_spawn(x,y,monster,size):
	position = Vector2(x,y)
	spawnEffect.visible = true
	targ_monster = monster.instance()
	spawnEffect.play("Starter")

func _on_AnimatedSprite_animation_finished():
	if spawnEffect.animation == "Buffer":
		if (counter == bufferlength):
			spawnEffect.play("Spawn")
			return
		counter+=1
		return
	elif spawnEffect.animation == "Starter":
		counter=0
		spawnEffect.play("Buffer")
		return
	elif spawnEffect.animation == "Spawn":
		spawnEffect.stop()
		spawnEffect.visible = false
		spawn_monster()
