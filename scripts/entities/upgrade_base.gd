extends Node2D
class_name UpgradeBase

signal upgrade_placed(upgrade: UpgradeBase, position: Vector2)
signal upgrade_dragged(upgrade: UpgradeBase, position: Vector2)
signal upgrade_cancelled(upgrade: UpgradeBase)

@export var upgrade_name: String = "Base Upgrade"
@export var upgrade_description: String = "A basic upgrade"
@export var upgrade_cost: int = 100
@export var upgrade_scene: PackedScene
@export var preview_texture: Texture2D
@export var valid_placement_color: Color = Color.GREEN
@export var invalid_placement_color: Color = Color.RED

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var can_place: bool = false
var preview_sprite: Sprite2D
var placement_indicator: Node2D

func _ready() -> void:
	"""
	Initialize the upgrade with preview sprite and placement indicator.
	"""
	_setup_preview()
	_setup_placement_indicator()

func _setup_preview() -> void:
	"""
	Create a preview sprite for dragging visualization.
	"""
	preview_sprite = Sprite2D.new()
	preview_sprite.texture = preview_texture
	preview_sprite.modulate = Color.WHITE
	preview_sprite.visible = false
	add_child(preview_sprite)

func _setup_placement_indicator() -> void:
	"""
	Create a placement indicator for visual feedback.
	"""
	placement_indicator = Node2D.new()
	var indicator = Polygon2D.new()
	indicator.color = valid_placement_color
	indicator.polygon = PackedVector2Array([
		Vector2(-32, -32),
		Vector2(32, -32),
		Vector2(32, 32),
		Vector2(-32, 32)
	])
	placement_indicator.add_child(indicator)
	placement_indicator.visible = false
	add_child(placement_indicator)

func start_drag(global_pos: Vector2) -> void:
	"""
	Start dragging the upgrade from a global position.
	"""
	is_dragging = true
	drag_offset = global_position - global_pos
	preview_sprite.visible = true
	placement_indicator.visible = true
	upgrade_dragged.emit(self, global_pos)

func update_drag(global_pos: Vector2) -> void:
	"""
	Update the drag position and check placement validity.
	"""
	if not is_dragging:
		return

	global_position = global_pos # + drag_offset
	can_place = _check_placement_validity(global_position)
	_update_visual_feedback()
	upgrade_dragged.emit(self, global_pos)

func end_drag(global_pos: Vector2) -> void:
	"""
	End dragging and either place the upgrade or cancel.
	"""
	if not is_dragging:
		return
	
	is_dragging = false
	preview_sprite.visible = false
	placement_indicator.visible = false
	
	if can_place:
		_place_upgrade(global_pos)
	else:
		upgrade_cancelled.emit(self)

func _check_placement_validity(pos: Vector2) -> bool:
	"""
	Check if the upgrade can be placed at the given position.
	Override this in subclasses for specific placement rules.
	"""
	# Basic implementation - check if position is within BaseTerrain bounds
	return GameState.level_bounds().has_point(pos)

func _update_visual_feedback() -> void:
	"""
	Update visual feedback based on placement validity.
	"""
	if can_place:
		preview_sprite.modulate = valid_placement_color
		placement_indicator.get_child(0).color = valid_placement_color
	else:
		preview_sprite.modulate = invalid_placement_color
		placement_indicator.get_child(0).color = invalid_placement_color

func _place_upgrade(pos: Vector2) -> void:
	"""
	Place the upgrade at the given position.
	Override this in subclasses for specific placement logic.
	"""
	if upgrade_scene:
		var instance = upgrade_scene.instantiate()
		get_parent().add_child(instance)
		instance.global_position = pos
		upgrade_placed.emit(self, pos)
		queue_free()

func get_upgrade_info() -> Dictionary:
	"""
	Return upgrade information for UI display.
	"""
	return {
		"name": upgrade_name,
		"description": upgrade_description,
		"cost": upgrade_cost,
		"texture": preview_texture
	} 