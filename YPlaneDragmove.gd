extends "res://PlaneDragmove.gd"

var selected : bool = false;
var start_position : Vector3
var start_offset : Vector3

################################################################################
# When selected create a plane that is perpendicular to the camera in the xz
# space and perfectly vertical in the y space. We will then use the y-value
# of the intersection between the mouse and this plane to determine the y-value
# of the gizmo.
################################################################################
func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = self.get_parent().position
	camera = _camera

	var node_pos: Vector2 = Vector2(self.get_parent().position.x, self.get_parent().position.z)
	var plane_range: Vector2 = Vector2(camera.transform.basis.z.x, camera.transform.basis.z.z)

	var k = plane_range.x * node_pos.x + plane_range.y * node_pos.y

	# In the planar format of [0]x + [1]y +[2]z = [3]
	plane = [plane_range.x, 0, plane_range.y, k]

	start_offset = get_offset_coordinates(event)

	print("Pillar Selected")


################################################################################
#
################################################################################
func _input(event : InputEvent):
	if selected:
		if event is InputEventMouseButton:
			if not event.pressed and event.button_index == 1:
				print("Deselected plane")
				selected = false
				_show_hover()
		elif event is InputEventMouseMotion:
			var new_offset = get_offset_coordinates(event)

			var delta_offset = new_offset - start_offset
			# Lock Changes to only the y axis
			delta_offset.x = 0
			delta_offset.z = 0

			get_parent().position = start_position + delta_offset

var hovered = false
func hover():
	hovered = true
	_show_hover()
func unhover():
	hovered = false;
	if !selected:
		_show_hover()

func _show_hover():
	$ArrowMesh.get_surface_override_material(0).hovering = hovered
