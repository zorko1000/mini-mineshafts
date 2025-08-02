# camera_2d.gd
# Camera2D controller for zooming and panning a side scrolling view.
# Handles mouse wheel zoom at cursor and keyboard panning.
# Follows Godot 4.4 strict typing and style conventions.

extends Camera2D

@export var terrain_scene: Node2D
@export var min_zoom: float = 0.14
@export var max_zoom: float = 1.0

var cam_velocity: Vector2 = Vector2.ZERO
const ZOOM_VELOCITY: float = 0.02  # Speed of zooming: 1=immediate, 0=not at all
const ZOOM_STEP: float = 1.5

var target_zoom: float
var target_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	"""
	Initializes the camera's target zoom to the current zoom level.
	"""
	# super()
	target_zoom = zoom.x

var is_dragging: bool = false

func _input(event: InputEvent) -> void:
	"""
	Handles mouse wheel input for zooming at the cursor position.
	Adds camera dragging and "throwing" with the left mouse button.
	"""
	  
	if event is InputEventMouseButton:
		var me: InputEventMouseButton = event
		me = self.make_input_local(me)

		# Mouse wheel zoom
		if me.pressed and me.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = zoom.x * ZOOM_STEP
			target_pos = me.position

		elif me.pressed and me.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = zoom.x / ZOOM_STEP
			target_pos = me.position

		# Start dragging
		elif me.pressed and me.button_index == MOUSE_BUTTON_LEFT && not UpgradeDragManager.is_dragging():
			is_dragging = true
	

		# End dragging and apply "throw"
		elif not me.pressed and me.button_index == MOUSE_BUTTON_LEFT and is_dragging:
			is_dragging = false
			cam_velocity = Vector2.ZERO

	if event is InputEventMouseMotion and is_dragging && not UpgradeDragManager.is_dragging():
		var motion: InputEventMouseMotion = event
		var delta: Vector2 = motion.relative

		var scaled_delta: Vector2 = delta / zoom
		# offset -= scaled_delta
		global_position -= scaled_delta
	



func _process(_delta: float) -> void:
	"""
	Handles smooth zooming and keyboard-based camera panning.
	"""
	if target_zoom != zoom.x:
		var zoom_step: float = ((target_zoom / zoom.x) - 1.0) * ZOOM_VELOCITY + 1.0
		zoom_at(zoom_step, target_pos)

	if Input.is_action_pressed("up"):
		cam_velocity.y -= 0.001

	elif Input.is_action_pressed("down"):
		cam_velocity.y += 0.001
	else:
		cam_velocity.y *= 0.998

	if Input.is_action_pressed("left"):
		cam_velocity.x -= 0.001
	elif Input.is_action_pressed("right"):
		cam_velocity.x += 0.001
	else:
		cam_velocity.x *= 0.998

	global_position += cam_velocity	
	# offset += cam_velocity

func zoom_at(zoom_factor: float, zoom_pos: Vector2) -> void:
	"""
	Zooms the camera at a specific global position.
	"""
	var new_zoom = zoom * zoom_factor
	new_zoom = new_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

	var cam_offset: Vector2 = zoom_pos 
	self.global_position -= cam_offset * zoom
	self.zoom = new_zoom
	self.global_position += cam_offset * zoom

    
    