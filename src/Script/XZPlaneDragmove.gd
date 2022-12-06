extends GizmoPlane


func apply_transform(_position : Vector3):
	node.global_position = _position
	print(_position,node.global_position)
	parent.global_position = _position
