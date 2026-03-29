extends CharacterBody3D

@export_group("Movement")
@export var walk_speed: float = 2.0
@export var sprint_speed: float = 4.0
@export var acceleration: float = 0.8
@export var deceleration: float = 0.1

@export_group("Jumping")
@export var jump_velocity: float = 4.5
@export var gravity_scale: float = 1.0

@export_group("Camera")
@export var mouse_sensitivity: float = 0.1

@export_group("Vaulting")
@export var vault_duration: float = 0.5

@onready var camera = $Camera3D
@onready var flashlight = $Camera3D/Flashlight
@onready var ledge_detector = $LedgeDetector
@onready var ledge_validator = $LedgeValidator

var _gravity: float
var is_vaulting: bool = false
var static_stress: float = 0.0

signal stress_changed(new_stress: float)

func _ready() -> void:
	_gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_scale
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	if event.is_action_just_pressed("flashlight"):
		flashlight.visible = not flashlight.visible
	
	if event.is_action_just_pressed("vault") and can_vault():
		perform_vault()

func _physics_process(delta: float) -> void:
	if is_vaulting:
		return

	# Gravity
	if not is_on_floor():
		velocity.y -= _gravity * delta

	# Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var is_sprinting = Input.is_action_pressed("sprint")
	var speed = sprint_speed if is_sprinting else walk_speed

	var target_velocity = direction * speed

	if direction != Vector3.ZERO:
		velocity.x = lerp(velocity.x, target_velocity.x, acceleration)
		velocity.z = lerp(velocity.z, target_velocity.z, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, deceleration)
		velocity.z = lerp(velocity.z, 0.0, deceleration)

	move_and_slide()

	# Stress
	static_stress = clamp(static_stress + 0.1 * delta, 0.0, 100.0)
	stress_changed.emit(static_stress)

func can_vault() -> bool:
	return ledge_detector.is_colliding() and not ledge_validator.is_colliding()

func perform_vault() -> void:
	is_vaulting = true
	var vault_start = global_transform.origin
	var vault_end = ledge_detector.get_collision_point() + Vector3(0, 1, 0)

	var tween = create_tween()
	tween.tween_property(self, "global_transform.origin", vault_end, vault_duration).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func(): is_vaulting = false)
