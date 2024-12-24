extends RayCast3D
@onready var water = $"../../Node3D"
@onready var camera_3d: Camera3D = $"../Node3D/Camera3D"
@onready var character =%CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	water.visible = false
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera_3d.project_ray_origin(mousepos)
	var end = origin + camera_3d.project_ray_normal(mousepos) * 100
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if result:
		if result.collider.is_class("Area3D") && result.collider.name != "Water":
			print_debug("Вижу")
			print_debug(result.position, result.collider.name)
			character.position.x = result.position.x
			character.position.z = result.position.z
		elif result.collider.name == "Water":
			water.visible = true
	else:
		print_debug("Не вижу")
