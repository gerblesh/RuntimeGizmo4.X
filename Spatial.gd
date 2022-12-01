extends Node3D

# How long the ray to search for 3D clickable object should be.
# Shorter is faster but cannot click thing far away.
# Longer is slower but can click things farther away.
var ray_length = 1000

# The last object that was hovered by the mouse. May be null, may be a dangling
# reference to a non-existant node.
var last_hover = null

# The last object that was selected by a click. May be null, may be a dangling
# reference to a non-existant node.
var last_selected = null

func cast_ray_from_camera(event: InputEvent,camera : Camera3D) -> Dictionary:
	var start_coordinate : Vector3 = camera.project_ray_origin(event.position)
	var end_coordinate : Vector3 = start_coordinate + camera.project_ray_normal(event.position) * ray_length
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_param : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_param.from = start_coordinate
	ray_param.to = end_coordinate
	return space_state.intersect_ray(ray_param)


################################################################################
# Hand the mouse input of clicking and hovering over an object
################################################################################
func _input(event : InputEvent) -> void:
	# If the left mouse button is clicked.
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		# Emit a ray from the mouse position to see if it intersects with any
		# clickable items.
#		var camera : Camera3D = $Camera3D
#		var start_coordinate : Vector3 = camera.project_ray_origin(event.position)
#		var end_coordinate : Vector3 = start_coordinate + camera.project_ray_normal(event.position) * ray_length
#		var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
#		var ray_param : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
#		ray_param.from = start_coordinate
#		ray_param.to = end_coordinate
		var camera : Camera3D = $Camera3D
		var result : Dictionary = cast_ray_from_camera(event,camera)

		# If if the ray intersects with a node then the mouse successfully
		# clicked something.
		if result:
			if is_instance_valid(last_selected) and last_selected.has_method("clear_selection") and last_selected != result["collider"].get_parent():
				last_selected.clear_selection()
			# Call the select() function checked the object that was clicked
			result["collider"].select(camera, event)
			last_selected = result["collider"].get_parent()
		else:
			if is_instance_valid(last_selected) and last_selected.has_method("clear_selection"):
				last_selected.clear_selection()
			last_selected = null

	# If the mouse is moved.
	if event is InputEventMouseMotion:
		# Emit a ray from the mouse position to see if it intersects with any
		# clickable items.
		var camera : Camera3D = $Camera3D
#		var start_coordinate : Vector3 = camera.project_ray_origin(event.position)
#		var end_coordinate : Vector3 = start_coordinate + camera.project_ray_normal(event.position) * self.ray_length
#		var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var result : Dictionary = cast_ray_from_camera(event,camera)

		# If the ray intersects with a node then the mouse is visually hovering
		# over something.
		if result:
			# If there is something that is currently hovered then unhover it
			if is_instance_valid(last_hover) and last_hover.has_method("unhover") and last_hover != result["collider"]:
				last_hover.unhover()
			# Call the hover function checked the new object that is being hovered
			result["collider"].hover()
			last_hover = result["collider"]
		# If nothing is hovere then try to unhover the object and set the
		# currently hovered object to null.
		else:
			if is_instance_valid(last_hover) and last_hover.has_method("unhover"):
				last_hover.unhover()
			last_hover = null
