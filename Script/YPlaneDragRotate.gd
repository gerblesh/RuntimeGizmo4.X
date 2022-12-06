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
	var orig_rot : float = node_center.angle_to_point(event.position - event.relative)
	var rot : float = node_center.angle_to_point(event.position)
	var diff : float = rot - orig_rot
	
	node.rotate(axis,-diff)
