extends Control
@onready var title_button: Button = %TitleButtonEnd
@onready var quit_button: Button = %QuitButtonEnd


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_button.pressed.connect(_on_return_to_title)
	quit_button.pressed.connect(_on_quit_game)
	
func _on_return_to_title():
	get_tree().change_scene_to_file("res://title_screen.tscn")
	
func _on_quit_game():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
