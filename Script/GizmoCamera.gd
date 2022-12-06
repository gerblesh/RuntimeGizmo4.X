extends Camera3D

@export var world_camera : Camera3D
@export var viewport : SubViewport


func _process(delta):
	global_transform = world_camera.global_transform
#	viewport.size = DisplayServer.window_get_real_size()
	
