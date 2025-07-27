extends Node2D

@export var instantiate_ball:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _input(event):
	if(event is InputEventMouseButton):
		var me:InputEventMouseButton = event
		me = self.make_input_local(me)
		if(me.pressed and me.button_index==MOUSE_BUTTON_LEFT):
			var ib:RigidBody2D = instantiate_ball.instantiate()
			add_child(ib)
			ib.position = me.position
			ib.set_axis_velocity(Vector2.from_angle(randf()*PI+PI)*(max(randf(),randf())*1500))
			ib.scale = Vector2(1,1)*(randf()+0.25)
			print("Left Mouse clicked at: ",me.position)
		
