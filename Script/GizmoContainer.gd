extends Node3D

@onready var camera : Camera3D = get_viewport().get_camera_3d()
@export var node : Node3D
func _process(delta):
	scale = Vector3.ONE * (camera.global_position.distance_to(global_position) / 3)
