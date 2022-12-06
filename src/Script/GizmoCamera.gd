extends Camera3D

@export var world_camera : Camera3D


func _process(delta):
	global_transform = world_camera.global_transform
