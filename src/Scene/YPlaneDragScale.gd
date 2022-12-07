extends YPlaneGizmo


var start_scale : Vector3

func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = node.global_position
	camera = _camera

	var node_pos: Vector2 = Vector2(node.global_position.x, node.global_position.z)
	var plane_range: Vector2 = Vector2(camera.global_transform.basis.z.x, camera.global_transform.basis.z.z)

	var k = plane_range.x * node_pos.x + plane_range.y * node_pos.y

	# In the planar format of [0]x + [1]y +[2]z = [3]
	plane = [plane_range.x, 0.0, plane_range.y, k]

	start_offset = get_offset_coordinates(event,camera,plane)

	start_scale = node.scale

func apply_transform(_position : Vector3):
	node.scale = start_scale + (_position)
