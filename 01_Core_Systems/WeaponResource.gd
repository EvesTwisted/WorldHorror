extends Resource
class_name WeaponResource

@export var item_name: String = "Unknown Weapon"
@export var ammo_type: String = "9mm"
@export var current_ammo: int = 15
@export var max_ammo: int = 15
@export var fire_rate: float = 0.1
@export var visuals: PackedScene # This is where you'll drag your weapon .gltf later
