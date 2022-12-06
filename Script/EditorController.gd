extends Node3D

var mouse_down : bool = false
var velocity : Vector3 = Vector3.ZERO
var speed : int = 5 : 
	set (value):
		speed = clampi(value,2,40)
		speed_changed.emit(value)
	get:
		return speed
signal speed_changed(speed)

@onready var cam : Camera3D = $Head/WorldCamera
@onready var head : Node3D = $Head

func _physics_process(delta : float):
	var direction : Vector3 = Vector3.ZERO
	if mouse_down:
		var input_dir = Input.get_vector("editor_move_left", "editor_move_right", "editor_move_forward", "editor_move_backward")
		direction = (cam.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.lerp(Vector3.ZERO, 0.1)
	global_position += delta * velocity

func _unhandled_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		mouse_down = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_viewport().set_input_as_handled()
		if event is InputEventMouseMotion:
			var sens : float = 10 * 0.01 * get_viewport().content_scale_factor
			var x_change : float = deg_to_rad(event.relative.x) * -sens
			var y_change : float = deg_to_rad(event.relative.y) * -sens
			cam.rotate_x(y_change)
			head.rotate_y(x_change)
		var scroll_axis : int = Input.get_axis("ui_scroll_down","ui_scroll_up")
		speed += scroll_axis
	else:
		mouse_down = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
