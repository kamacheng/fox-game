extends Area2D

enum ENEMY_TYPE{
	mormal,
	elite,
	boss
}



@export var max_speed: float = -100
@export var hp: int = 3
@export var score: int = 2
@export var damage: int = 1
@export var enemy_type: ENEMY_TYPE

@export var item_cherry: PackedScene
@export var item_carrot: PackedScene
@export var item_gem: PackedScene
@export var item_star: PackedScene
@export var item_acron: PackedScene



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
		drop_item()
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

	# 取消敌人区域检测
	self.set_deferred("monitoring",false)
	self.set_deferred("monitorable",false)

	enemy_dead.emit(score)
	await animated_sprite.animation_finished
	queue_free()


func drop_item():
	match enemy_type:
		ENEMY_TYPE.mormal:
			if randf() > 0.9:
				var cherry = item_cherry.instantiate()
				cherry.position = position
				get_tree().current_scene.add_child(cherry)
				return
			if randf() > 0.85:
				var arcon = item_acron.instantiate()
				arcon.position = position
				get_tree().current_scene.add_child(arcon)
				return
			if randf() > 0.8:
				var star = item_star.instantiate()
				star.position = position
				get_tree().current_scene.add_child(star)
				return
			if randf() > 0.7:
				var carrot = item_carrot.instantiate()
				carrot.position = position
				get_tree().current_scene.add_child(carrot)
				return
			if randf() > 0.6:
				var gem = item_gem.instantiate()
				gem.position = position
				get_tree().current_scene.add_child(gem)
				return
			
			
		ENEMY_TYPE.elite:
			if randf() > 0.8:
				pass
		ENEMY_TYPE.boss:
			var cherry = item_cherry.instantiate()
			cherry.position = position
			get_tree().current_scene.add_child(cherry)
	
	
	
	
	pass
