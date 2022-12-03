extends StaticBody3D


@export var parent : Node3D
@onready var node : Node3D = parent.node
@export var meshes : Array[NodePath]
@export var axis : Vector3


var selected : bool = false;
var start_position : Vector3
var mouse_start : Vector2


func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = parent.position
#	camera = _camera
#
#	# Define a flat plane at the height of the current y value
#	plane = [0, 1, 0, start_position.y]
#
	mouse_start = event.position


func gizmo_tick(event : InputEvent) -> void:
	var new_offset : Vector2= event.position
	var mouse_delta : float
	if (new_offset - mouse_start).x > 0:
		mouse_delta = (event.relative).length()
	else:
		mouse_delta = (event.relative).length() * -1
	# Lock unchecked y axis movement so this only is xz
	var offset : Vector3 = mouse_delta * axis * 0.01
	node.global_position += offset
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
