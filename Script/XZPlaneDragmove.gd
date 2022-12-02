extends PlaneDragMove

@export var meshes : Array[NodePath]

var selected : bool = false;
var start_position : Vector3
var start_offset : Vector3


func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = get_parent().position
	camera = _camera

	# Define a flat plane at the height of the current y value
	plane = [0, 1, 0, get_parent().position.y]
	
	start_offset = get_offset_coordinates(event,camera,plane)


func gizmo_tick(event : InputEvent) -> void:
	if selected:
		if event is InputEventMouseButton:
			if not event.pressed and event.button_index == 1:
				print("Deselected plane")
				selected = false
				_show_hover()
		elif event is InputEventMouseMotion:
			var new_offset = get_offset_coordinates(event,camera,plane)
			var delta_offset = new_offset - start_offset

			var angle_diff = (camera.position - (self.start_position + delta_offset)).dot(camera.transform.basis.z)
			if (angle_diff < 0):
				# not colliding with plane, return
				return

			# Lock unchecked y axis movement so this only is xz
			delta_offset.y = 0

			# This should be a square instead of a circle
			if delta_offset.length_squared() > 10000:
				delta_offset = delta_offset * 100/delta_offset.length()

			node.global_position = start_position + delta_offset
			parent.global_position = node.global_position

# some simple functions for hovering, should probably make these more portable

var hovered : bool = false
func hover() -> void:
	hovered = true
	_show_hover()

func unhover() -> void:
	hovered = false;
	if !selected:
		_show_hover()

func _show_hover():
	for mesh_path in meshes:
		get_node(mesh_path).get_surface_override_material(0).hovering = hovered
