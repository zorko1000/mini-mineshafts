extends UpgradeBase
class_name RockUpgrade

func _ready() -> void:
	"""
	Initialize the rock upgrade with specific properties.
	"""
	upgrade_name = "Rock"
	upgrade_description = "Throw a rock for the fun of it"
	upgrade_cost = 0
	valid_placement_color = Color(0.2, 0.8, 0.2, 0.7)  # Green with transparency
	invalid_placement_color = Color(0.8, 0.2, 0.2, 0.7)  # Red with transparency
	super()

