extends CharacterBody3D

@export_group("Movement")
@export var walk_speed: float = 2.0
@export var sprint_speed: float = 4.0
@export var acceleration: float = 10.0 # Using a higher value for snappier response

@export_group("Jumping")
@export var jump_velocity: float = 4.5
@export var gravity_scale: float = 1.0

@export_group("Camera")
@export var mouse_sensitivity: float = 0.1
@export var camera_smoothing: float = 15.0
@export var lean_angle: float = 15.0

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var pivot = $Pivot
@onready var camera = $Pivot/character_t_pose_amy_rebel/Armature/Skeleton3D/HeadBone/Camera3D
@onready var flashlight = $Pivot/character_t_pose_amy_rebel/Armature/Skeleton3D/RightHandBone/Flashlight

var _gravity: float
var jump_buffer_timer: float = 0.0

func _ready() -> void:
	_gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_scale
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_tree.active = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x + deg_to_rad(-event.relative.y * mouse_sensitivity), deg_to_rad(-80), deg_to_rad(80))

	if event.is_action_just_pressed("flashlight"):
		flashlight.visible = not flashlight.visible

func _physics_process(delta: float) -> void:
	# --- Animation Parameters ---
	var input_dir_anim = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	animation_tree.set("parameters/BlendSpace2D/blend_position", input_dir_anim)

	# --- Player Logic ---
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
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var is_sprinting = Input.is_action_pressed("sprint")
	var speed = sprint_speed if is_sprinting else walk_speed

	var target_velocity = direction * speed
	velocity.x = lerp(velocity.x, target_velocity.x, acceleration * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, acceleration * delta)

	# TODO: Implement Additive Lean
	# TODO: Implement "Weight Skid" state change based on rapid direction change
	# TODO: Implement "Static Stress" camera shake and hand jitter

	move_and_slide()

# Placeholder for vaulting
func can_vault():
	pass

# Placeholder for stance transitions
func set_stance(stance: String):
	pass
