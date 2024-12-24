extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.004
const AMPLITUDE = 0.1
const FREQUENCY = 5.0

@onready var head = $Node3D
@onready var camera = $Node3D/Camera3D
@onready var dust_particles = $CPUParticles3D
#@onready var raycast = $RayCast3D

var time_passed = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	dust_particles.emitting = false
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.length() > 0:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		dust_particles.emitting = false
		
	dust_particles.emitting = velocity.length() > 0
	dust_particles.global_transform.origin = global_transform.origin + Vector3(0, 1, 0)
		
	time_passed += delta * velocity.length() * float(is_on_floor())
	var pos = Vector3.ZERO
	pos.y = sin(time_passed * FREQUENCY) * AMPLITUDE
	pos.x = cos(time_passed * FREQUENCY / 2) * AMPLITUDE
	camera.transform.origin = pos

	move_and_slide()
	
