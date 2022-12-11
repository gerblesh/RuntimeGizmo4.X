extends Node3D

@onready var camera : Camera3D = get_viewport().get_camera_3d()

@export var selected_node : Node3D

var gizmo_container_idx : int = 0
var packed_gizmos : Array[PackedScene] = [
	preload("res://src/Scene/TranslateGizmo.tscn"),
	preload("res://src/Scene/ScaleGizmo.tscn"),
]



var selected_gizmo : Node3D
var last_hover : Node3D
const ray_length = 10000

func _ready():
	select_object(selected_node,packed_gizmos[gizmo_container_idx])

func cast_ray_from_camera(event: InputEvent,camera : Camera3D) -> Dictionary:
	var start_coordinate : Vector3 = camera.project_ray_origin(event.position)
	var end_coordinate : Vector3 = start_coordinate + camera.project_ray_normal(event.position) * ray_length
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_param : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_param.collision_mask = 2
	ray_param.from = start_coordinate
	ray_param.to = end_coordinate
	return space_state.intersect_ray(ray_param)

################################################################################
# Hand the mouse input of clicking and hovering over an object
################################################################################
func _unhandled_input(event : InputEvent) -> void:
	# temp gizmo changing
	if Input.is_key_pressed(KEY_W):
		select_object(selected_node,packed_gizmos[0])
		get_viewport().set_input_as_handled()
		return
	if Input.is_key_pressed(KEY_E):
		select_object(selected_node,packed_gizmos[1])
		get_viewport().set_input_as_handled()
		return
	
	# If the left mouse button is clicked.
	if event is InputEventMouseButton and event.button_index == 1:
		get_viewport().set_input_as_handled()
		if not event.pressed:
			if !is_instance_valid(selected_gizmo):
				return
			selected_gizmo.selected = false
			selected_gizmo._show_hover()
			selected_gizmo = null
			return
		
		# Emit a ray from the mouse position to see if it intersects with any
		# clickable items.
		var result : Dictionary = cast_ray_from_camera(event,camera)

		# If if the ray intersects with a node then the mouse successfully
		# clicked something.
		if result:
			# Call the select() function checked the object that was clicked
			selected_gizmo = result.collider
			selected_gizmo.select(camera, event)
		else:
			selected_gizmo = null

	# If the mouse is moved.
	if event is InputEventMouseMotion:
		get_viewport().set_input_as_handled()
		if is_instance_valid(selected_gizmo):
			selected_gizmo.gizmo_tick(event)
			return
		# Emit a ray from the mouse position to see if it intersects with any
		# clickable items.
		var result : Dictionary = cast_ray_from_camera(event,camera)

		# If the ray intersects with a node then the mouse is visually hovering over something
		if result:
			# If there is something that is currently hovered then unhover it
			if is_instance_valid(last_hover) and last_hover != result.collider:
				last_hover.unhover()
				last_hover = null
				return
			# Call the hover function checked the new object that is being hovered
			last_hover = result.collider
			last_hover.hover()

		# If nothing is hovere then try to unhover the object and set the
		# currently hovered object to null.
		elif is_instance_valid(last_hover):
			last_hover.unhover()
			last_hover = null

func select_object(node : Node3D, gizmo_scene : PackedScene):
	clear_runtime_gizmo()
	var gizmo : Node3D = gizmo_scene.instantiate()
	gizmo.global_position = node.global_position
	gizmo.node = node
	add_child(gizmo)

func clear_runtime_gizmo():
	selected_gizmo = null
	for child in get_children():
		child.queue_free()
