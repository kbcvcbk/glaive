extends KinematicBody2D

var facing_dir : Vector2
var move_vector : Vector2
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
		move_vector.y += gravity
	
	if abs(move_vector.x) > 450:
		move_vector.x 
	
	if move_vector.x > 0:
		move_vector.x -= speed_damp
		if move_vector.x > speed_max:
			move_vector.x = speed_max
	elif move_vector.x < 0:
		move_vector.x += speed_damp
		if move_vector.x < -speed_max:
			move_vector.x = -speed_max
	
	move_vector = move_and_slide(move_vector, Vector2.UP, true)
	
	if Input.is_action_just_pressed("attack"):
		attack()

func set_glaive_angle(angle):
	$glaive.rotation = angle

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
			move_vector.x += speed_front
		else:
			move_vector.x += speed_back
	if Input.is_action_pressed("move_left"):
		if facing_dir == Vector2.LEFT:
			move_vector.x -= speed_front
		else:
			move_vector.x -= speed_back
	if Input.is_action_just_pressed("jump"):
		move_vector.y = speed_jump

func attack():
	$animator.play("attack")