extends Node2D

signal spawn(x,y,monster,size)

onready var bird = preload("res://Objects/Bird.tscn")

func _ready():
	emit_signal("spawn", 100, 100,bird,1)
