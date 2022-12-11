extends LineDrag

class_name LineDragTranslate




func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = node.global_position
	camera = _camera

	start_offset = get_offset_coordinates(event,camera,start_position,axis)


################################################################################
#
################################################################################
func gizmo_tick(event : InputEvent):
	var new_offset = get_offset_coordinates(event,camera,start_position,axis)
	var delta_offset = new_offset - start_offset

	apply_transform(start_position + delta_offset)

func apply_transform(_position : Vector3):
	node.global_position = _position
	parent.global_position = node.global_position
