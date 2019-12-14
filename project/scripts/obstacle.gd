tool
extends StaticBody2D

export (int, 0, 2) var lane = 0
var y_offset = -55
onready var lanes = get_tree().get_nodes_in_group("lane")

func _ready():
	if lanes && lanes.size() > 0:
		lanes[lane].position.y + y_offset
		self.set_collision_layer_bit(lane + 1, 1)
		self.z_index = lane

func _process(_delta):
	if lanes && lanes.size() > 0:
		self.position.y = lanes[lane].position.y + y_offset
	