extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var base_speed: float = 500
@export var speed_multiplier: float = 2.0
@export var fireball_scene: PackedScene

var is_shotting: bool = false
var is_moving: bool = false
var is_jumping: bool =false
var is_face_left: bool = false
var current_speed: float = base_speed
var is_dead: bool = false

signal player_dead

func _ready() -> void:
	await get_tree().process_frame
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer != null:
		player_dead.connect(ui_layer._on_player_dead)



func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_dead:
		$StepSound.stop()
	elif not $StepSound.playing :
		$StepSound.play()

func _physics_process(delta: float) -> void:
	if is_shotting:
		return

	if not is_dead:
		velocity = Input.get_vector("left","right","up","down") * current_speed
		
		if velocity == Vector2.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
		move_and_slide()


func game_over() -> void:
	is_dead = true
	animated_sprite.play("hurt")
	player_dead.emit()
	$RestartTimer.start()
	await $RestartTimer.timeout
	#await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()


func _on_timer_timeout() -> void:
	is_shotting = true
	if not is_shotting  or velocity != Vector2.ZERO or is_dead:
		is_shotting = false
		return

	animated_sprite.play("shot")
	await  animated_sprite.animation_finished
	var fireball = fireball_scene.instantiate()
	fireball.position = position + Vector2(0,12)
	get_tree().current_scene.add_child(fireball)
	is_shotting = false
