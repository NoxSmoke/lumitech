extends Area2D

signal collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_body_entered(body: Node2D) -> void:
	print("TRiggered")
	if body.name == "Player":
		collected.emit()
		queue_free()
