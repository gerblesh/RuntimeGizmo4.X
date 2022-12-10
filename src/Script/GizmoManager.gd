extends Node3D

@onready var camera : Camera3D = get_viewport().get_camera_3d()


var selected_gizmo : Node3D
var last_hover : Node3D
const ray_length = 10000


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
	# If the left mouse button is clicked.
	if event is InputEventMouseButton and event.button_index == 1:
		get_viewport().set_input_as_handled()
		if not event.pressed:
			if !is_instance_valid(selected_gizmo):
				return
			print("Deselected plane")
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
	for child in get_children():
		child.queue_free()
	var gizmo : Node3D = gizmo_scene.instantiate()
	gizmo.node = node
	add_child(gizmo)
