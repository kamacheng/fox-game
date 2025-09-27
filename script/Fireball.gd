extends Area2D

@export var speed: float = 500



func _physics_process(delta: float) -> void:
	position += Vector2(speed,0) * delta
