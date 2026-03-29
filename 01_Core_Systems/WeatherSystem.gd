extends Node

@onready var world_environment = get_tree().get_first_node_in_group("WorldEnvironment")
@onready var glitch_effect = get_tree().get_root().find_child("GlitchEffect", true, false)

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.stress_changed.connect(_on_stress_changed)

func _on_stress_changed(new_stress: float) -> void:
	if world_environment:
		var env = world_environment.environment
		if new_stress > 50:
			env.volumetric_fog_density = 0.1
			env.background_energy_multiplier = 0.5
		else:
			env.volumetric_fog_density = 0.01
			env.background_energy_multiplier = 1.0

	if glitch_effect and glitch_effect.material is ShaderMaterial:
		glitch_effect.material.set_shader_parameter("stress", new_stress / 100.0)
