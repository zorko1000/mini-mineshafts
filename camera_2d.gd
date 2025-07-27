extends Camera2D

var cam_velocity = Vector2.ZERO
var ZOOM_VELOCITY = 0.02  # speed of zooming: 1=immidiate, 0=not at all
var ZOOM_STEP:float = 2;

var target_zoom:float
var target_pos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_zoom = zoom.x


func _input(event):
	if(event is InputEventMouseButton):
		var me:InputEventMouseButton = event
		me = self.make_input_local(me)

		if(me.pressed and me.button_index==MOUSE_BUTTON_WHEEL_UP):
			target_zoom = zoom.x*ZOOM_STEP
			target_pos = me.position
			
		if(me.pressed and me.button_index==MOUSE_BUTTON_WHEEL_DOWN):
			target_zoom = zoom.x/ZOOM_STEP
			target_pos = me.position
		
		print(target_zoom, target_pos)
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if(target_zoom!=zoom.x):
		var zoomStep = ((target_zoom/zoom.x)-1)*ZOOM_VELOCITY+1
		zoom_at(zoomStep, target_pos)
		
		
	if Input.is_action_pressed("up"):
		cam_velocity.y -= 0.001
	else: 
		if Input.is_action_pressed("down"):
			cam_velocity.y += 0.001
		else: 
			cam_velocity.y *= 0.998
	
	if Input.is_action_pressed("left"):
		cam_velocity.x -= 0.001
	else: 
		if Input.is_action_pressed("right"):
			cam_velocity.x += 0.001
		else: 
			cam_velocity.x *= 0.998
	
	offset += (cam_velocity);
	
func zoom_at(zoom_factor:float, global_pos:Vector2):
	var cam_offset = global_pos - self.offset
	self.offset -= cam_offset
	zoom *= zoom_factor
	self.offset += cam_offset*zoom_factor
