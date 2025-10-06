extends RigidBody3D

var pos_obj
func _ready() -> void:
	$Node3D.visible= true
	$CollisionShape3D.visible = true
func _physics_process(delta: float) -> void:
	if pos_obj:
		global_transform.origin = pos_obj.global_transform.origin

func hit_obj(body: Node) -> void:
	pos_obj = body
	freeze = true

func toggle_body():
	disconnect("body_exited", Callable(self, "hit_obj"))
	freeze = true
