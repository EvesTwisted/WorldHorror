extends CharacterBody3D

@export_group("Movement")
@export var walk_speed: float = 2.0
@export var sprint_speed: float = 4.0
@export var acceleration: float = 0.8

@export_group("Jumping")
@export var jump_velocity: float = 4.5
@export var gravity_scale: float = 1.0

@export_group("Camera")
@export var mouse_sensitivity: float = 0.1
@export var camera_smoothing: float = 15.0
@export var lean_angle: float = 15.0

@onready var flashlight = $Eve/Armature/Skeleton3D/Head/BoneAttachment3D/Camera3D/Flashlight
@onready var camera = $Eve/Armature/Skeleton3D/Head/BoneAttachment3D/Camera3D
@onready var head = $Eve/Armature/Skeleton3D/Head

var _gravity: float
var jump_buffer_timer: float = 0.0

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
	# Jump Buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		else:
			jump_buffer_timer = 0.2
	
	if is_on_floor() and jump_buffer_timer > 0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0

	# Gravity
	if not is_on_floor():
		velocity.y -= _gravity * delta

	# Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var is_sprinting = Input.is_action_pressed("sprint")
	var speed = sprint_speed if is_sprinting else walk_speed

	var target_velocity = direction * speed
	velocity.x = lerp(velocity.x, target_velocity.x, acceleration * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, acceleration * delta)

	# Lean
	var lean_input = Input.get_axis("lean_left", "lean_right")
	var target_lean = lean_input * deg_to_rad(lean_angle)
	head.rotation.z = lerp(head.rotation.z, target_lean, camera_smoothing * delta)

	move_and_slide()

# Placeholder for vaulting
func can_vault():
	pass

# Placeholder for stance transitions
func set_stance(stance: String):
	pass
