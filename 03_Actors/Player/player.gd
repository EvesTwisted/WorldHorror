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

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var flashlight = $Head/Camera3D/Flashlight

var _gravity: float

func _ready() -> void:
	_gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_scale
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x + deg_to_rad(-event.relative.y * mouse_sensitivity), deg_to_rad(-80), deg_to_rad(80))

	if event.is_action_just_pressed("flashlight"):
		flashlight.visible = not flashlight.visible

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= _gravity * delta

	# Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
