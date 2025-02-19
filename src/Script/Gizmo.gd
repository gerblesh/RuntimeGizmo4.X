extends StaticBody3D

class_name Gizmo

var highlight_mtl : StandardMaterial3D = preload("res://src/Asset/Material/Highlight.tres")

@export var axis : Vector3
@export var meshes : Array[NodePath]
@export var parent : Node3D
@onready var node : Node3D = parent.node
@onready var camera : Camera3D

var selected : bool = false
var start_position : Vector3
var start_offset : Vector3

func _ready():
	_show_hover()

func select(_camera : Camera3D, event : InputEvent) -> void:
	selected = true
	start_position = parent.position
	camera = _camera


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
		if hovered:
			get_node(mesh_path).material_overlay = highlight_mtl
		else:
			get_node(mesh_path).material_overlay = null

# passthrough

func gizmo_tick(_event : InputEvent) -> void:
	pass
