extends Area2D

@export var speed: float = 500
@export var damage: int
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_flying: bool = true

func _ready() -> void:
	damage = get_tree().get_first_node_in_group("player").damage

func _physics_process(delta: float) -> void:
	if is_flying:
		fly(delta)

func hit():
	animated_sprite_2d.play("hit")
	print("hit func")
	is_flying = false
	await  animated_sprite_2d.animation_finished
	queue_free()

func fly(delta: float):
	position += Vector2(speed,0) * delta
