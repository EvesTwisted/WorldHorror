extends Node

var primary_weapon_slot: WeaponResource
var secondary_weapon_slot: WeaponResource
var ammo_pouch: Array
var grid_data: Array

signal total_weight_updated(new_weight: float)

func get_total_inventory_weight() -> float:
	var total_weight = 0.0
	if primary_weapon_slot:
		total_weight += primary_weapon_slot.weight
	if secondary_weapon_slot:
		total_weight += secondary_weapon_slot.weight

	for ammo_stack in ammo_pouch:
		total_weight += ammo_stack.weight

	var counted_items = []
	for item in grid_data:
		if item and not item in counted_items:
			total_weight += item.weight
			counted_items.append(item)

	total_weight_updated.emit(total_weight)
	return total_weight
