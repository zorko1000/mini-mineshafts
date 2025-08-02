extends TextureButton
class_name UpgradeButton

signal upgrade_selected(upgrade_scene: PackedScene)

@export var upgrade_scene: PackedScene

var upgrade_preview_texture: Texture2D
var upgrade_name: String = "Upgrade"
var upgrade_description: String = "An upgrade"
var upgrade_cost: int = 100

var tooltip: Control

func _ready() -> void:
	"""
	Initialize the upgrade button with tooltip and drag manager reference.
	"""
	if(upgrade_scene):
		var upgrade_instance = upgrade_scene.instantiate()
		if upgrade_instance is UpgradeBase:
			upgrade_name = upgrade_instance.upgrade_name
			upgrade_description = upgrade_instance.upgrade_description
			upgrade_cost = upgrade_instance.upgrade_cost
			upgrade_preview_texture = upgrade_instance.preview_texture

	_setup_tooltip()
	_setup_button()

func _setup_tooltip() -> void:
	"""
	Create a tooltip that shows upgrade information on hover.
	"""
	tooltip = Control.new()
	tooltip.visible = false
	tooltip.z_index = 1000
	
	var tooltip_bg = ColorRect.new()
	tooltip_bg.color = Color(0.1, 0.1, 0.1, 0.9)
	tooltip_bg.size = Vector2(200, 80)
	tooltip.add_child(tooltip_bg)
	
	
	var tooltip_label = Label.new()
	tooltip_label.text = "%s\n%s\nCost: %d" % [upgrade_name, upgrade_description, upgrade_cost]
	tooltip_label.position = Vector2(10, 10)
	tooltip_label.size = Vector2(180, 60)
	tooltip_label.add_theme_color_override("font_color", Color.WHITE)
	tooltip.add_child(tooltip_label)
	
	add_child(tooltip)
	

func _setup_button() -> void:
	"""
	Set up button properties and connect signals.
	"""
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	connect("pressed", _on_button_pressed)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_button_pressed() -> void:
	"""
	Handle button press - create upgrade instance and start drag.
	"""
	
	if not upgrade_scene:
		return
	
	# Create upgrade instance
	var upgrade_instance = upgrade_scene.instantiate()
	if upgrade_instance is UpgradeBase:
		# Set up the upgrade with our properties
		
		#upgrade_instance.upgrade_name = upgrade_name
		#upgrade_instance.upgrade_description = upgrade_description
		#upgrade_instance.upgrade_cost = upgrade_cost
		#upgrade_instance.preview_texture = upgrade_preview_texture
		#upgrade_instance.upgrade_scene = upgrade_scene
		
		# Add to scene and start dragging
		get_tree().current_scene.add_child(upgrade_instance)
		UpgradeDragManager.set_dragged_upgrade(upgrade_instance)
		
		# Emit signal for other systems that might need to know
		upgrade_selected.emit(upgrade_scene)
	else:
		push_error("UpgradeButton: upgrade_scene does not contain an UpgradeBase!")

func _on_mouse_entered() -> void:
	"""
	Show tooltip when mouse enters button.
	"""
	if tooltip:
		tooltip.visible = true

func _on_mouse_exited() -> void:
	"""
	Hide tooltip when mouse leaves button.
	"""
	if tooltip:
		tooltip.visible = false

func _process(_delta: float) -> void:
	"""
	Update tooltip position to follow mouse.
	"""
	if tooltip and tooltip.visible:
		var mouse_pos = get_global_mouse_position()
		tooltip.global_position = mouse_pos + Vector2(20, 20) 