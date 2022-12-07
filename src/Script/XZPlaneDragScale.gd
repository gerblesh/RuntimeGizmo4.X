extends GizmoPlane

var start_scale : Vector3

func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = node.global_position
	camera = _camera

	# Define a flat plane at the height of the current y value
	plane = [plane_normal.x, plane_normal.y, plane_normal.z, parent.position.y]

	start_offset = get_offset_coordinates(event,camera,plane)
	start_scale = node.scale

func apply_transform(_position : Vector3):
	node.scale = start_scale + (_position * 2 * axis)
