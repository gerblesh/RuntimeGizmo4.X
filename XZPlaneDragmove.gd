extends "res://PlaneDragmove.gd"

var selected : bool = false;
var start_position : Vector3
var start_offset : Vector3


func select(camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = get_parent().position
	camera = camera

	# Define a flat plane at the height of the current y value
	plane = [0, 1, 0, get_parent().position.y]
	start_offset = get_offset_coordinates(event)


func _input(event : InputEvent) -> void:
	if selected:
		if event is InputEventMouseButton:
			if not event.pressed and event.button_index == 1:
				print("Deselected plane")
				selected = false
				_show_hover()
		elif event is InputEventMouseMotion:
			var new_offset = get_offset_coordinates(event)
			var delta_offset = new_offset - start_offset

			# Catch if the new position is behind the camera, if so flip it
			# because it is probably a horizon cross
			var angle_diff = (camera.position - (self.start_position + delta_offset)).dot(camera.transform.basis.z)
			if (angle_diff < 0):
				return
				print(angle_diff)
				delta_offset = -delta_offset + (self.start_position - camera.position)

			# Lock unchecked y axis movement so thi s only is xz
			delta_offset.y = 0

			# This should be a square instead of a circle
			if delta_offset.length_squared() > 10000:
				delta_offset = delta_offset * 100/delta_offset.length()

			get_parent().position = start_position + delta_offset

var hovered : bool = false
func hover() -> void:
	hovered = true
	_show_hover()

func unhover() -> void:
	hovered = false;
	if !selected:
		_show_hover()

func _show_hover():
	$ArrowMesh.get_surface_override_material(0).hovering = hovered
	$ArrowMesh2.get_surface_override_material(0).hovering = hovered
