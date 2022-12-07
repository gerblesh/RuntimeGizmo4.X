extends PlaneDragMove

class_name YPlaneGizmo



################################################################################
# When selected create a plane that is perpendicular to the camera in the xz
# space and perfectly vertical in the y space. We will then use the y-value
# of the intersection between the mouse and this plane to determine the y-value
# of the gizmo.
################################################################################

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

	print("Pillar Selected")


################################################################################
#
################################################################################
func gizmo_tick(event : InputEvent):
	var new_offset = get_offset_coordinates(event,camera,plane)
	var delta_offset = new_offset - start_offset

	# Lock Changes to only the y axis
	delta_offset.x = 0
	delta_offset.z = 0

	apply_transform(start_position + delta_offset)

func apply_transform(_position : Vector3):
	node.global_position = _position
	parent.global_position = node.global_position
