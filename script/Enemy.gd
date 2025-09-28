extends Area2D

@export var speed: float = -100
var is_alive: bool = true

signal enemy_dead

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	await get_tree().process_frame
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer != null:
		enemy_dead.connect(ui_layer._on_enemy_dead)



func _physics_process(delta: float) -> void:
	if is_alive:
		position += Vector2(speed,0) * delta


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.game_over()
		$Gameover.play()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("fireball"):
		is_alive = false
		area.queue_free()
		animated_sprite.play("dead")
		$EnemyDeadAudio.play()
		enemy_dead.emit()		# send signal
		await animated_sprite.animation_finished
		queue_free()
