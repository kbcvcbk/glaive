extends KinematicBody2D

enum states {jumping, cooldown}
var c_state = states.cooldown

var player_pos
var speed = 100
var jump = -500
var gravity = 30
var move_vec = Vector2.ZERO

func _physics_process(delta):
	player_pos = get_tree().get_nodes_in_group("player")[0].get_global_position()
	if (player_pos - global_position).x < 0:
		$sprite.flip_h = true
	else:
		$sprite.flip_h = false
	
	if c_state == states.cooldown:
		if $cooldown.time_left == 0:
			move_vec.x += speed * (player_pos - global_position).normalized().x
			move_vec.y = jump
			c_state = states.jumping
	elif c_state == states.jumping:
		move_vec.y += gravity
		if is_on_floor():
			move_vec = Vector2.ZERO
			$cooldown.start()
			c_state = states.cooldown
	move_and_slide(move_vec, Vector2.UP)
