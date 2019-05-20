extends KinematicBody2D

var mounted_char : Sprite

var facing_dir : Vector2
var move_vec : Vector2
var gravity = 2
var gravity_max = 500
var speed_jump = -1000
var speed_front = 3
var speed_back = 2
var speed_damp = 1
var speed_max = 450

func _process(delta):
	var mouse_angle = get_global_mouse_position().angle_to_point(get_global_position())
	set_glaive_angle(mouse_angle)
	set_face_dir(mouse_angle)
	
	handle_input()
	if gravity < gravity_max:
		move_vec.y += gravity
	
	if abs(move_vec.x) > 450:
		move_vec.x 
	
	if move_vec.x > 0:
		move_vec.x -= speed_damp
		if move_vec.x > speed_max:
			move_vec.x = speed_max
	elif move_vec.x < 0:
		move_vec.x += speed_damp
		if move_vec.x < -speed_max:
			move_vec.x = -speed_max
	
	move_vec = move_and_slide(move_vec, Vector2.UP, true)
	
	if Input.is_action_just_pressed("attack"):
		attack()

func set_glaive_angle(angle):
	$glaive.rotation = angle
	$raycast.rotation = angle

func set_face_dir(angle):
	if abs(angle) > PI/2:
		facing_dir = Vector2.LEFT
		$char.flip_h = true
	else:
		facing_dir = Vector2.RIGHT
		$char.flip_h = false

func handle_input():
	if Input.is_action_pressed("move_right"):
		if facing_dir == Vector2.RIGHT:
			move_vec.x += speed_front
		else:
			move_vec.x += speed_back
	if Input.is_action_pressed("move_left"):
		if facing_dir == Vector2.LEFT:
			move_vec.x -= speed_front
		else:
			move_vec.x -= speed_back
	if Input.is_action_just_pressed("jump"):
		move_vec.y = speed_jump

func attack():
	$animator.play("attack")
	$raycast.enabled = true
	while $animator.is_playing():
		print($animator.is_playing())
		if $raycast.is_colliding():
			var mob: Node = $raycast.get_collider()
			if mob.is_in_group("mobs"):
				mob.hit()
	$raycast.enabled = false