tool
extends StaticBody2D

export (int, 0, 2) var lane = 0
var y_offset = -55

func _ready():
	self.position.y = get_tree().get_nodes_in_group("lane")[lane].position.y + y_offset
	self.set_collision_layer_bit(lane + 1, 1)
	self.z_index = lane
	print(self.z_index)

func _process(_delta):
	self.position.y = get_tree().get_nodes_in_group("lane")[lane].position.y + y_offset
	