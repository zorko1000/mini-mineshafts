extends UpgradeBase
class_name MineshaftUpgrade

@export var mineshaft_scene: PackedScene
@export var min_distance_from_other_mineshafts: float = 200.0

func _ready() -> void:
	"""
	Initialize the mineshaft upgrade with specific properties.
	"""
	upgrade_name = "Mineshaft"
	upgrade_description = "Extract resources from the terrain"
	upgrade_cost = 150
	valid_placement_color = Color(0.2, 0.8, 0.2, 0.7)  # Green with transparency
	invalid_placement_color = Color(0.8, 0.2, 0.2, 0.7)  # Red with transparency
	super()

func _check_placement_validity(pos: Vector2) -> bool:
	"""
	Check if a mineshaft can be placed at the given position.
	"""
	# First check basic terrain bounds
	# breakpoint
	if not super._check_placement_validity(pos):
		return false
	
	# Check distance from other mineshafts
	var existing_mineshafts = get_tree().get_nodes_in_group("mineshafts")
	for mineshaft in existing_mineshafts:
		if mineshaft.global_position.distance_to(pos) < min_distance_from_other_mineshafts:
			return false
	
	# Check if position is on valid terrain (not too steep, etc.)
	return _check_terrain_validity(pos)

func _check_terrain_validity(pos: Vector2) -> bool:
	"""
	Check if the terrain at the given position is suitable for a mineshaft.
	"""
	# This is a simplified check - you can make this more sophisticated
	# by checking terrain slope, height, or other properties
	
	# For now, just check if it's within the BaseTerrain polygon
	var base_terrain = get_node_or_null("/root/Level01/BaseTerrain")
	if base_terrain:
		# Convert global position to local position relative to BaseTerrain
		var local_pos = base_terrain.to_local(pos)
		
		# Simple polygon containment check
		# In a real implementation, you'd want to use Geometry2D.point_in_polygon
		return local_pos.x > 0 and local_pos.x < 50000 and local_pos.y > 0 and local_pos.y < 20000
	
	return false

func _place_upgrade(pos: Vector2) -> void:
	"""
	Place the mineshaft upgrade at the given position.
	"""
	if mineshaft_scene:
		var mineshaft_instance = mineshaft_scene.instantiate()
		mineshaft_instance.add_to_group("mineshafts")
		get_parent().add_child(mineshaft_instance)
		mineshaft_instance.global_position = pos
		upgrade_placed.emit(self, pos)
		queue_free()
	else:
		# Fallback to base implementation
		super._place_upgrade(pos) 