extends Node

@onready var world_environment = get_tree().get_first_node_in_group("WorldEnvironment")

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.stress_changed.connect(_on_stress_changed)

func _on_stress_changed(new_stress: float) -> void:
	if world_environment:
		var env = world_environment.environment
		if new_stress < 30:
			env.volumetric_fog_density = 0.05
			print("Weather: Clear Skies")
		elif new_stress > 70:
			env.volumetric_fog_density = 0.2
			print("Weather: Heavy Fog")
