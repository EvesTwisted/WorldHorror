extends Node

func _ready() -> void:
	# This assumes the player is added to the scene and is in a group named "Player"
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.stress_changed.connect(_on_stress_changed)

func _on_stress_changed(new_stress: float) -> void:
	if new_stress < 30:
		print("Weather: Clear Skies")
	elif new_stress > 70:
		print("Weather: Heavy Fog and Static Rain")
