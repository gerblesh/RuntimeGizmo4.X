extends Node3D

var camera: Camera3D
var selected: bool = false

func clear_selection():
	self.selected = false
	$Node/CollisionShape3D.disabled = false
	$Plane.hide()
	$Plane/CollisionShape3D.disabled = true
	$Pillar.hide()
	$Pillar/CollisionShape3D.disabled = true

func select(camera, event):
	self.selected = true
	self.camera = camera
	$Node/CollisionShape3D.disabled = true
	$Plane.show()
	$Plane/CollisionShape3D.disabled = false
	$Pillar.show()
	$Pillar/CollisionShape3D.disabled = false


################################################################################
# Handle resizing the control nodes so that no matter how far away from the
# camera they appear to be the same pixel size checked-screen. Without this it will
# be harder to click checked the arrows for things that are farther awawy.
################################################################################
func _process(delta):
	if (selected):
		var distance_to_camera = position.distance_to(camera.position) / 5
		var new_scale = Vector3(
			distance_to_camera,
			distance_to_camera,
			distance_to_camera
		)
		$Plane.scale = new_scale
		$Pillar.scale = new_scale
