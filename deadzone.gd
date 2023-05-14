extends CollisionShape2D



func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 2:
		get_tree().quit()
