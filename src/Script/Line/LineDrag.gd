extends Gizmo

class_name LineDrag

func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = parent.position
	camera = _camera


func intersect(line_origin : Vector3, line_normal : Vector3, ray_origin : Vector3, ray_normal : Vector3) -> Vector3:
	var difference : Vector3 = line_origin - ray_origin
	var cross_normal : Vector3 = line_normal.cross(ray_normal).normalized()
	var rejection : Vector3 = difference - difference.project(ray_normal) - difference.project(cross_normal)
	var signed_distance_to_line : float = rejection.length() / line_normal.dot(rejection.normalized())
	var closest_approach : Vector3 = line_origin - line_normal * signed_distance_to_line
	return closest_approach


func get_offset_coordinates(event : InputEvent, _camera : Camera3D,line_origin : Vector3,  line_normal : Vector3) -> Vector3:
	var ray_origin : Vector3 = _camera.project_ray_origin(event.position)
	var ray_normal : Vector3 = _camera.project_ray_normal(event.position)
	
	return intersect(line_origin,line_normal,ray_origin,ray_normal)
