extends GizmoPlane

func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = parent.position
	camera = _camera

	# Define a flat plane at the height of the current y value
	plane = [plane_normal.x, plane_normal.y, plane_normal.z, parent.position.y]

	start_offset = get_offset_coordinates(event,camera,plane)


func apply_transform(_position : Vector3):
	node.global_position = _position
	print(_position,node.global_position)
	parent.global_position = _position
