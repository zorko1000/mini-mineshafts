extends Node2D

@export var instantiate_ball: PackedScene



func _ready() -> void:
	"""
	Initialize this level in global game state and upgrade drag manager.
	"""
	GameState.register_level_scene(self)
	_setup_upgrade_drag_manager()
	

func _setup_upgrade_drag_manager() -> void:
	
	# Connect signals for upgrade placement
	UpgradeDragManager.upgrade_placed.connect(_on_upgrade_placed)
	UpgradeDragManager.upgrade_cancelled.connect(_on_upgrade_cancelled)

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	"""
	Handle input events for ball instantiation and upgrade management.
	"""
	# if event is InputEventMouseButton:
	# 	var me: InputEventMouseButton = event
	# 	me = self.make_input_local(me)
	# 	if me.pressed and me.button_index == MOUSE_BUTTON_LEFT:
	# 		# Only instantiate ball if not dragging an upgrade
	# 		if not upgrade_drag_manager or not upgrade_drag_manager.current_dragged_upgrade:
	# 			var ib: RigidBody2D = instantiate_ball.instantiate()
	# 			add_child(ib)
	# 			ib.position = me.position
	# 			ib.set_axis_velocity(Vector2.from_angle(randf() * PI + PI) * (max(randf(), randf()) * 1500))
	# 			ib.scale = Vector2(1, 1) * (randf() + 0.25)


func _on_upgrade_placed(upgrade: UpgradeBase, position: Vector2) -> void:
	"""
	Handle when an upgrade is successfully placed.
	"""
	print("Upgrade placed at: ", position)
	# Add any additional logic here (resource management, effects, etc.)

func _on_upgrade_cancelled(upgrade: UpgradeBase) -> void:
	"""
	Handle when an upgrade placement is cancelled.
	"""
	print("Upgrade placement cancelled")
	# Add any cleanup logic here
		
