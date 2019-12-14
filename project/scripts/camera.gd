extends Camera2D

export (float, 0, 540) var my_offset = 200

func _process(delta):
	self.position.x = (-my_offset) + get_tree().get_nodes_in_group("player")[0].position.x