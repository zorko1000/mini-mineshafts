extends Node2D


signal upgrade_placed(upgrade: UpgradeBase, position: Vector2)
signal upgrade_cancelled(upgrade: UpgradeBase)

var current_dragged_upgrade: UpgradeBase = null
var drag_started: bool = false

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	"""
	Handle input events for drag-and-drop functionality.
	"""
	if not current_dragged_upgrade:
		return
	
	# the position of the mouse taking camera viewport into account
	var level_mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()

	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed and not drag_started:
				# Start dragging
				_start_drag(level_mouse_pos)
			elif not mouse_event.pressed and drag_started:
				# End dragging
				_end_drag(level_mouse_pos)
	
	elif event is InputEventMouseMotion and drag_started:
		# Update drag position
		_update_drag(level_mouse_pos)

func _start_drag(global_pos: Vector2) -> void:
	"""
	Start dragging an upgrade from the given global position.
	"""
	if current_dragged_upgrade:
		drag_started = true
		current_dragged_upgrade.start_drag(global_pos)

func _update_drag(global_pos: Vector2) -> void:
	"""
	Update the drag position and provide visual feedback.
	"""
	if current_dragged_upgrade and drag_started:
		current_dragged_upgrade.update_drag(global_pos)

func _end_drag(global_pos: Vector2) -> void:
	"""
	End dragging and handle placement or cancellation.
	"""
	if current_dragged_upgrade and drag_started:
		current_dragged_upgrade.end_drag(global_pos)
		drag_started = false
		clear_dragged_upgrade() 
		# Connect to upgrade signals
		#if not current_dragged_upgrade.upgrade_placed.is_connected(_on_upgrade_placed):
	    #	current_dragged_upgrade.upgrade_placed.connect(_on_upgrade_placed)
		#if not current_dragged_upgrade.upgrade_cancelled.is_connected(_on_upgrade_cancelled):
		#	current_dragged_upgrade.upgrade_cancelled.connect(_on_upgrade_cancelled)

func set_dragged_upgrade(upgrade: UpgradeBase) -> void:
	"""
	Set the upgrade that will be dragged.
	"""
	current_dragged_upgrade = upgrade
	if upgrade:
		# Position the upgrade at mouse position
		var mouse_pos = get_local_mouse_position()
		upgrade.global_position = mouse_pos
		_start_drag(mouse_pos)

func clear_dragged_upgrade() -> void:
	"""
	Clear the currently dragged upgrade.
	"""
	if current_dragged_upgrade:
		current_dragged_upgrade.queue_free()
		current_dragged_upgrade = null
	drag_started = false

func _on_upgrade_placed(upgrade: UpgradeBase, upgrade_position: Vector2) -> void:
	"""
	Handle when an upgrade is successfully placed.
	"""
	upgrade_placed.emit(upgrade, upgrade_position)
	clear_dragged_upgrade()

func _on_upgrade_cancelled(upgrade: UpgradeBase) -> void:
	"""
	Handle when an upgrade placement is cancelled.
	"""
	upgrade_cancelled.emit(upgrade)
	clear_dragged_upgrade() 


func is_dragging() -> bool:
	"""
	Check if the UI is dragging (and thus processing mouse events)
	"""
	return drag_started;