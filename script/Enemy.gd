extends Area2D

@export var max_speed: float = -100
@export var hp: int = 3
@export var score: int = 2
@export var damage: int = 1

var is_alive: bool = true
var curren_speed: float = 0
var is_flashing: bool = false

signal enemy_dead

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	await get_tree().process_frame
	var ui_layer = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer != null:
		enemy_dead.connect(ui_layer._get_score)


func _physics_process(delta: float) -> void:
	if is_alive:
		move(delta)
		#position += Vector2(max_speed,0) * delta


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.hurt(damage)
		#body.game_over()
		$Gameover.play()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("fireball"):
		hurt(area.damage)
		area.hit()


func hurt(player_damage: int):
	hp -= player_damage
	if hp > 0 :
		curren_speed = 0
		flash_white()
	else:
		die()


func flash_white():
	if is_flashing:
		return
	animated_sprite.modulate = Color(10,10,10)
	var tween = create_tween()
	tween.tween_property(animated_sprite,"modulate",Color(1,1,1),0.1)
	tween.finished.connect(_on_flash_finished)


func _on_flash_finished():
	is_flashing = false


func move(delta: float):
	if curren_speed != max_speed:
		curren_speed = lerp(curren_speed, max_speed , 0.1)
	position += Vector2(curren_speed , 0) * delta


func die():
	is_alive = false
	animated_sprite.play("dead")
	$EnemyDeadAudio.play()
	enemy_dead.emit(score)
	await animated_sprite.animation_finished
	queue_free()
