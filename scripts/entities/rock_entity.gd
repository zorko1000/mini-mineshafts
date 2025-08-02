extends RigidBody2D

@export var flightParticles:GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(flightParticles!=null):
		flightParticles.emitting = (self.linear_velocity.length()>300)
	pass

func _on_body_entered(_body: Node) -> void:
	pass # Replace with function body.


func _on_body_exited(_body: Node) -> void:
	pass # Replace with function body.
