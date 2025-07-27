extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var poly := CollisionPolygon2D.new()
	poly.polygon = polygon
	poly.position = position
	# get_parent().call_deferred("add_child", poly)
	# get_parent().add_child(poly)
	$StaticBody2D.add_child(poly)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
