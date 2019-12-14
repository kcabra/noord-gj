extends KinematicBody2D

export var moving = true

var lanes_pos : Array
var current_lane : int = 1
var vel = 100

func _ready():
	var lanes_pos_group = get_tree().get_nodes_in_group("lane")
	for lane in lanes_pos_group:
		lanes_pos.append(lane.position.y)
	_change_lane(0)

func _physics_process(delta):
	if Input.is_action_just_pressed("move_up"):
		_change_lane(-1)
		

	if Input.is_action_just_pressed("move_down"):
		_change_lane(+1)
	
	var move_vec = lerp(0, lanes_pos[current_lane] - self.position.y, 0.5)
	vel += 1 if vel < 500 && moving else 0
	
	var collision = move_and_collide(Vector2(vel * (delta if moving else 0), move_vec))
	if collision:
		moving = false
		_explode()

func _change_lane(change):
	if moving:
		current_lane += change if current_lane + change <= 2 &&  current_lane + change >= 0 else 0
		self.z_index = current_lane
		print(self.z_index)
		for i in range(3):
			set_collision_mask_bit(i + 1, (1 if i == current_lane else 0))

func _explode():
	var scene = load("res://objects/Explosion.tscn").instance()
	scene.position = self.position - Vector2(0, 40)
	get_parent().add_child(scene)