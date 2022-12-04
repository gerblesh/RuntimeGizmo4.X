extends PlaneGizmo
var start_rot : Vector3

func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = parent.position
	camera = _camera

	# Define a flat plane at the height of the current y value
	plane = [plane_normal.x, plane_normal.y, plane_normal.z, parent.position.y]
	
	start_offset = get_offset_coordinates(event,camera,plane)
	start_rot = node.rotation
#	start_basis = node.global_transform.basis.z + node.global_position
	

func apply_transform(_position : Vector3):
	node.look_at(start_offset)
	var orig_rot : Vector3 = node.rotation
	node.look_at(_position)
	var new_rot : Vector3 = node.rotation
	node.rotation = start_rot + (new_rot - orig_rot)
#	node.rotate_y(node.global_position.angle_to(_position))
#	node.look_at_from_position(node.global_position,_position)
