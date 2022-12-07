extends GizmoPlane


func apply_transform(_position : Vector3):
	node.global_position = _position
	parent.global_position = _position
