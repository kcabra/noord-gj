extends KinematicBody2D

enum states {ACTIVE, INACTIVE}
var state = states.ACTIVE

export var moving = true

var move_timer
var lanes_pos : Array
var current_lane : int = 1
var gravity = 40
var climbing = false
var vel = 100
var move_y = 0
var jumped = false

func _ready():
	move_timer = Timer.new()
	move_timer.wait_time = 0.3
	move_timer.one_shot = true
	add_child(move_timer)
	move_timer.connect("timeout", $CollisionShape2D, "set_disabled", [false] )
	var lanes_pos_group = get_tree().get_nodes_in_group("lane")
	for lane in lanes_pos_group:
		lanes_pos.append(lane.global_position.y)
	_change_lane(0)

func _physics_process(delta):
	match state:
		states.ACTIVE:
			if Input.is_action_just_pressed("move_up"):
				_change_lane(-1)
			if Input.is_action_just_pressed("move_down"):
				_change_lane(+1)
			if Input.is_action_just_pressed("move_jump"):
				move_y = -13
				jumped = true
		
			if move_timer.time_left > 0:
				$CollisionShape2D.disabled = true
				move_y = lerp(0, (lanes_pos[current_lane]) - self.position.y, 0.5)
			elif !$RayCast2D.is_colliding() && !climbing:
				move_y += gravity * delta
			elif !jumped:
				move_y = 0
			vel += 1 if vel < 500 && moving else 0
			climbing = false
			var collision = move_and_collide(Vector2(vel * (delta if moving else 0), move_y))
			if collision && (collision.normal == Vector2.LEFT):
				moving = false
				_explode()
			elif (collision && _is_slope(collision.normal)):
				move_and_collide(2 * collision.remainder.slide(collision.normal))
				climbing = true
			jumped = false

func _change_lane(change):
	if moving:
		move_timer.start()
		current_lane += change if current_lane + change <= 2 &&  current_lane + change >= 0 else 0
		self.z_index = current_lane
		for i in range(3):
			set_collision_mask_bit(i + 1, (1 if i == current_lane else 0))
		for i in range(3):
			$RayCast2D.set_collision_mask_bit(i + 1, (1 if i == current_lane else 0))

func _explode():
	var scene = load("res://objects/Explosion.tscn").instance()
	scene.position = self.position - Vector2(0, 40)
	get_parent().add_child(scene)

func _is_slope(normal):
	return (normal.angle() >= -PI) && (normal.angle() <= -PI/2)