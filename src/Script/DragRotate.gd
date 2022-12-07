extends Gizmo

var start_rot : Vector3
var node_center : Vector2

func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = node.global_position
	camera = _camera
	node_center = camera.unproject_position(start_position)
	start_rot = node.rotation

func gizmo_tick(event : InputEvent):
	var original_rotation : float = node_center.angle_to_point(event.position - event.relative)
	var new_rotation : float = node_center.angle_to_point(event.position)
	var rads : float = new_rotation - original_rotation

	var direction_to_camera : Vector3 = camera.global_position.direction_to(node.global_position)

	var idx : int = axis.max_axis_index()
	var mult : float = sign(direction_to_camera[idx])
	node.rotate(axis,mult * rads)
