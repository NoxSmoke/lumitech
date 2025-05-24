extends CharacterBody2D
@onready var animated2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var score_label: Label = $"../CanvasLayer/ScoreLabel"
@onready var win_label: Label = $"../CanvasLayer/WinLabel"
@onready var coin_label: Label = $"../HUD/HUDPanel/HUDBox/CoinLabel"
@onready var heart_label: Label = $"../HUD/HUDPanel/HUDBox/HeartLabel"
@onready var pause_menu: Control = %PauseMenu
@onready var jump_sfx: AudioStreamPlayer2D = %JumpSFX
@onready var collect_sfx: AudioStreamPlayer2D = %CollectSFX
@onready var win_sfx: AudioStreamPlayer2D = %WinSFX

@export var speed := 300
@export var jump_velocity := -600
var gravity := 1200
var score := 0
var lives := 3


func _on_player_hit():
	lives -= 1
	heart_label.text = "x %d" % lives
	
	
func _ready() -> void:
	for item in get_tree().get_nodes_in_group("Collectibles"):
		item.collected.connect(_on_collect)
	for goal in get_tree().get_nodes_in_group("Goal"):
		goal.goal_reached.connect(_on_goal_reached)
	pause_menu.visible = false
	
func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_cancel"):
			if get_tree().paused:
				resume_game()
			else:
				pause_game()

func pause_game():
	get_tree().paused = true
	pause_menu.visible = true

func resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	
	
func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://TitleScreen.tscn")

func _on_resume_button_pressed() -> void:
	resume_game()





func _on_goal_reached():
	get_tree().paused = true
	win_sfx.play()
	win_label.text = "We did it! \nBut this is just the beginning ..."
	win_label.visible = true
	
	await get_tree().create_timer(5.0).timeout
	get_tree().paused = false
	win_sfx.play()
	get_tree().change_scene_to_file("res://end_screen.tscn")
	

func _on_collect():
	score += 1  # correction , original after and update incorrect
	score_label.text = "Score: %d" % score
	coin_label.text = "x %d" % score
	collect_sfx.play()
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	# Jump input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		jump_sfx.play()

	# Animation state logic
	if not is_on_floor():
		animated2d.animation = "jump"
	elif direction != 0:
		animated2d.animation = "run"
	else:
		animated2d.animation = "idle"

	animated2d.flip_h = direction < 0

	move_and_slide()
