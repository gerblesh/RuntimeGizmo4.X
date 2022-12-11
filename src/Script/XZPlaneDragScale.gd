extends GizmoPlane

var start_scale : Vector3
var scale_axis : Vector3
@export var factor : float = 2.0
func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = node.global_position
	camera = _camera

	# Define a flat plane at the height of the current y value
	plane = [plane_normal.x, plane_normal.y, plane_normal.z, parent.position.y]

	start_offset = get_offset_coordinates(event,camera,plane)
	start_scale = node.scale

	# find the nearest global axis based on the basis of the object
	var axis_index : int = axis.max_axis_index()
	for i in 3:
		var vector = abs(node.global_transform.basis[i])
		if vector.max_axis_index() == axis_index:
			var new_axis : Vector3 = Vector3.ZERO
			new_axis[i] = 1
			scale_axis = new_axis

func apply_transform(_position : Vector3):
	node.scale = abs(start_scale + (_position[axis.max_axis_index()] * scale_axis * factor))
