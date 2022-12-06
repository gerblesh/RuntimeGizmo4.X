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
	var _rotation : float = node_center.angle_to_point(event.position)
	var rads : float = _rotation - original_rotation
	
	var face : Vector3 = camera.global_transform.basis.z
	var direction_to_camera : Vector3 = camera.global_position.direction_to(node.global_position).normalized()
	var mult : float = 1.0
	if face.dot(direction_to_camera) < 0:
		mult = -1
	node.rotate(axis,mult * rads)
