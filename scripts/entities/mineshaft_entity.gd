extends StaticBody2D
class_name MineshaftEntity

# AI generated nonsense logic

signal resource_extracted(amount: int)

@export var extraction_rate: float = 1.0  # Resources per second
@export var max_resources: int = 1000
@export var current_resources: int = 0

var extraction_timer: Timer
var is_extracting: bool = false

func _ready() -> void:
	"""
	Initialize the mineshaft with extraction timer and visual feedback.
	"""
	_setup_extraction_timer()
	_setup_visual_feedback()

func _setup_extraction_timer() -> void:
	"""
	Create and configure the extraction timer.
	"""
	extraction_timer = Timer.new()
	extraction_timer.wait_time = 1.0 / extraction_rate
	extraction_timer.timeout.connect(_on_extraction_timer_timeout)
	add_child(extraction_timer)

func _setup_visual_feedback() -> void:
	"""
	Set up visual feedback for the mineshaft.
	"""
	# Add a progress bar or other visual indicator
	var progress_bar = ProgressBar.new()
	progress_bar.name = "ProgressBar"
	progress_bar.max_value = max_resources
	progress_bar.value = current_resources
	progress_bar.position = Vector2(-25, -80)
	progress_bar.size = Vector2(50, 10)
	add_child(progress_bar)

func start_extraction() -> void:
	"""
	Start extracting resources from the terrain.
	"""
	if not is_extracting and current_resources < max_resources:
		is_extracting = true
		extraction_timer.start()
		_update_visual_feedback()

func stop_extraction() -> void:
	"""
	Stop extracting resources.
	"""
	is_extracting = false
	extraction_timer.stop()
	_update_visual_feedback()

func _on_extraction_timer_timeout() -> void:
	"""
	Handle extraction timer timeout - extract resources.
	"""
	if current_resources < max_resources:
		current_resources += 1
		resource_extracted.emit(1)
		_update_visual_feedback()
		
		if current_resources >= max_resources:
			stop_extraction()

func _update_visual_feedback() -> void:
	"""
	Update visual feedback based on current state.
	"""
	var progress_bar = get_node_or_null("ProgressBar")
	if progress_bar:
		progress_bar.value = current_resources
	
	# Change color based on extraction status
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		if is_extracting:
			sprite.modulate = Color(1.0, 1.0, 0.5)  # Yellow when extracting
		else:
			sprite.modulate = Color.WHITE

func get_resource_info() -> Dictionary:
	"""
	Return current resource information.
	"""
	return {
		"current": current_resources,
		"max": max_resources,
		"extracting": is_extracting
	}

func _on_body_entered(body: Node2D) -> void:
	"""
	Handle when something enters the mineshaft area.
	"""
	# Could be used for player interaction or other entities
	pass

func _on_body_exited(body: Node2D) -> void:
	"""
	Handle when something exits the mineshaft area.
	"""
	# Could be used for player interaction or other entities
	pass 