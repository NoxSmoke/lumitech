extends Area2D
signal goal_reached




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# First time to introduce Unique Name in project 
	%WinLabel.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_body_entered(body: Node2D) ->void:
	print("entered by:", body.name)
	if body.name == "Player":
		goal_reached.emit()
